"""Cross-check the rank transition encoding against scalar execution."""
from pathlib import Path
import itertools
import json
import random
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, '/path/to/repo/agents/sat')
from pysat.solvers import Solver
from rank_encode import RankEnc

OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge']
randomizer = random.Random(530090)
checked = wrong_bits = 0
for index in range(80):
    nr = 9
    p = [(randomizer.randrange(6), randomizer.randrange(nr), randomizer.randrange(nr))
         for _ in range(18)]
    e = RankEnc(5, len(p), R=nr, iset='I1', outmode='snap', rules=())
    e.check_outputs = False
    for i, (op, d, s) in enumerate(p):
        e.cl(e.op[i][OPS[op]])
        e.cl(e.d[i][d])
        e.cl(e.s[i][s])
    cases = [tuple(randomizer.randrange(5) for _ in range(5)) for _ in range(5)]
    expected = []
    for case in cases:
        e.add_type(case)
        rs = list(case) + [7]*(nr-5)
        flag = 0
        trace = []
        for op, d, s in p:
            if op == 0:
                rs[d] = rs[s]
            elif op == 1:
                flag = (rs[d] > rs[s]) - (rs[d] < rs[s])
            elif ((op == 2 and flag < 0) or (op == 3 and flag <= 0)
                  or (op == 4 and flag > 0) or (op == 5 and flag >= 0)):
                rs[d] = rs[s]
            trace.append(rs[d])
        expected.append(trace)
    with Solver(name='cadical195', bootstrap_with=e.clauses) as solver:
        assert solver.solve(), index
        model = {x for x in solver.get_model() if x > 0}
        for case, trace in enumerate(expected):
            for i, rank in enumerate(trace):
                for bit, literal in enumerate(e.traces[case][i]):
                    actual = literal if type(literal) is bool else literal in model if literal > 0 else -literal not in model
                    assert actual == bool((rank >> bit) & 1), (index, case, i, bit, rank, actual)
                checked += 1
        # Make one fixed transition bit wrong. The circuit must reject it.
        bit = e.traces[0][-1][0]
        if type(bit) is not bool:
            correct = bit if expected[0][-1] & 1 else -bit
            assert not solver.solve(assumptions=[-correct]), index
            wrong_bits += 1
print(json.dumps(dict(programs=80, cases=400, transition_values=checked,
                      rejected_wrong_bits=wrong_bits, disagreements=0)))
