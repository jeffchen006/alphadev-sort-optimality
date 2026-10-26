#!/usr/bin/env python3
"""Constructive garbage elimination for M_out. Independent of shared/judge.py.

The compiler uses alias classes and a prefix cost invariant. See ../lemma.md.
An unresolved last output rejects compilation as a total garbage-free function.
"""
from dataclasses import dataclass, field
import argparse
import json
import re
from pathlib import Path

OPS = ('mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge')


def parse(text):
    code = []
    for line in text.splitlines():
        line = line.split('#', 1)[0].strip()
        if not line:
            continue
        op, a, b = re.split(r'[\s,]+', line)
        if op not in OPS + ('out',):
            raise ValueError(op)
        code.append((op, int(a) if op == 'out' else a, b))
    return code


def takes(op, flag):
    # flag is -1, 0, +1 for less, equal, greater.
    return {'cmovl': flag < 0, 'cmovle': flag <= 0,
            'cmovg': flag > 0, 'cmovge': flag >= 0}[op]


@dataclass(eq=False)
class Class:
    members: set = field(default_factory=set)
    rep: str | None = None
    variables: set = field(default_factory=set)


class Compiler:
    def __init__(self, n, names):
        self.n = n
        self.names = sorted(set(names) | {f'P{i}' for i in range(n)})
        self.reg = {}
        for name in self.names:
            self.reg[name] = Class({name}, name if name.startswith('P') else None,
                                   {name} if name.startswith('S') else set())
        self.code = []
        self.binds = []
        self.trace = []
        self.static_eq = True  # Restrict original initial flags to equality.
        self.fresh = 0
        self.consumed = 0
        self.outputs = {}
        self.unresolved_outputs = []

    def classes(self):
        return set(self.reg.values())

    def potential(self):
        return sum(len(c.members) - 1 for c in self.classes())

    def emit(self, op, a, b):
        self.code.append((op, a, b))

    def fresh_register(self):
        value = f'S{self.fresh}'
        self.fresh += 1
        return value

    def merge_unknown(self, a, b):
        if a is b:
            return
        assert a.rep is None or b.rep is None
        if a.rep is not None:
            a, b = b, a
        if b.rep is not None:
            self.binds.append((len(self.code), sorted(a.variables), b.rep))
        else:
            b.variables |= a.variables
        for name in a.members:
            self.reg[name] = b
        b.members |= a.members

    def move_alias(self, dest, source):
        a, b = self.reg[dest], self.reg[source]
        if a is b:
            return
        a.members.remove(dest)
        b.members.add(dest)
        self.reg[dest] = b

    def snapshot(self, j, name):
        c = self.reg[name]
        if c.rep is None:
            self.unresolved_outputs.append((j, name, sorted(c.variables)))
            return
        self.emit('out', j, c.rep)
        self.outputs[j] = c.rep

    def step(self, ins):
        op, dest, source = ins
        assert op != 'out'
        before_e = sum(x[0] != 'out' for x in self.code)
        before_p = self.potential()
        a, b = self.reg[dest], self.reg[source]
        if op == 'cmp':
            if a.rep is None or b.rep is None:
                self.merge_unknown(a, b)
                self.static_eq = True
            else:
                self.emit('cmp', a.rep, b.rep)
                self.static_eq = False
        elif op == 'mov' or self.static_eq:
            if op == 'mov' or takes(op, 0):
                self.move_alias(dest, source)
        elif a is b:
            pass
        elif a.rep is None or b.rep is None:
            self.merge_unknown(a, b)
        else:
            old = a.rep
            if len(a.members) > 1:
                target = self.fresh_register()
                self.emit('mov', target, old)
            else:
                target = old
            self.emit(op, target, b.rep)
            a.members.remove(dest)
            self.reg[dest] = Class({dest}, target)
        self.consumed += 1
        after_e = sum(x[0] != 'out' for x in self.code)
        after_p = self.potential()
        assert after_e - before_e + after_p - before_p <= 1
        assert after_e + after_p <= self.consumed
        self.trace.append({'instruction': ins, 'input_prefix': self.consumed,
                           'emitted': after_e, 'potential': after_p,
                           'static_eq': self.static_eq})

    def compile(self, code, include_defaults=True):
        last = {ins[1]: i for i, ins in enumerate(code) if ins[0] == 'out'}
        for i, ins in enumerate(code):
            if ins[0] == 'out':
                if last[ins[1]] == i:
                    self.snapshot(ins[1], ins[2])
            else:
                self.step(ins)
        if include_defaults:
            for j in range(self.n):
                if j not in last:
                    self.snapshot(j, f'P{j}')
        return self

    def text(self):
        if self.unresolved_outputs:
            raise ValueError(f'unresolved required output: {self.unresolved_outputs}')
        names = {str(x) for ins in self.code for x in ins[1:] if isinstance(x, str)}
        r = self.n + len([x for x in names if x.startswith('S')])
        return (f'# n={self.n} R={r} iset=I1 model=out source=w12_C1_normalization\n'
                + ''.join(f'{op} {a}, {b}\n' for op, a, b in self.code))


def normalize(code, n=5, defaults=True):
    names = set()
    for op, a, b in code:
        names.add(b)
        if op != 'out':
            names.add(a)
    return Compiler(n, names).compile(code, defaults)


def execute(code, state, flag=0):
    """Independent concrete interpreter; returns final state and snapshots."""
    state = dict(state)
    out = {}
    for op, a, b in code:
        if op == 'out':
            out[a] = state[b]
        elif op == 'cmp':
            flag = (state[a] > state[b]) - (state[a] < state[b])
        elif op == 'mov' or takes(op, flag):
            state[a] = state[b]
    return state, out


def check_specialization(original, compiler, inputs):
    """Reconstruct one legal original garbage assignment for each input.

    Compare *all* final logical registers, not only successful sorting outputs.
    Initial equality flags are an allowed specialization of the strict model.
    """
    state = {f'P{i}': value for i, value in enumerate(inputs)}
    flag = 0
    witness = {name: 0 for name in compiler.names if name.startswith('S')}
    events = {}
    for pc, variables, rep in compiler.binds:
        events.setdefault(pc, []).append((variables, rep))
    for pc in range(len(compiler.code) + 1):
        for variables, rep in events.get(pc, []):
            for name in variables:
                witness[name] = state[rep]
        if pc == len(compiler.code):
            break
        op, a, b = compiler.code[pc]
        if op == 'out':
            continue
        if op == 'cmp':
            flag = (state[a] > state[b]) - (state[a] < state[b])
        elif op == 'mov' or takes(op, flag):
            state[a] = state[b]
    old, _ = execute(original, {**{f'P{i}': x for i, x in enumerate(inputs)}, **witness})
    for name, c in compiler.reg.items():
        expected = state[c.rep] if c.rep is not None else witness[next(iter(c.variables))]
        assert old[name] == expected, (original, inputs, name, old[name], expected, witness)
    return witness


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input', type=Path)
    parser.add_argument('output', type=Path)
    parser.add_argument('--n', type=int, default=5)
    args = parser.parse_args()
    c = normalize(parse(args.input.read_text()), args.n)
    args.output.write_text(c.text())
    args.output.with_suffix('.trace.json').write_text(json.dumps(
        {'trace': c.trace, 'bindings': c.binds, 'input_k': c.consumed,
         'output_k': sum(x[0] != 'out' for x in c.code)}, indent=2) + '\n')


if __name__ == '__main__':
    main()
