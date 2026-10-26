#!/usr/bin/env python3
"""Independent finite checks of threshold arithmetic and the strict witness.

No SAT encoder, solver, or saved model is imported here.
"""
import itertools
import json
from pathlib import Path
import time


def check():
    start = time.monotonic()
    n = 3
    orders = list(itertools.permutations(range(n)))
    columns = list(itertools.product(range(n), repeat=len(orders)))
    lattice, inconsistent = [], 0
    for column in columns:
        observations = {mask: set() for mask in range(1, (1 << n)-1)}
        for ty, value in zip(orders, column):
            for threshold in range(1, n):
                mask = sum(1 << i for i,x in enumerate(ty) if x >= threshold)
                observations[mask].add(value >= threshold)
        conflict = any(len(bits) == 2 for bits in observations.values())
        if conflict:
            inconsistent += 1
            continue
        table = [False]+[next(iter(observations[mask])) for mask in range(1,(1 << n)-1)]+[True]
        assert all(not table[a] or table[b] for a in range(1 << n) for b in range(1 << n)
                   if a & b == a)
        # Evaluate the explicit max-of-mins expression, independently.
        terms = [mask for mask in range(1, 1 << n) if table[mask]]
        for ty, value in zip(orders, column):
            answer = max(min(ty[i] for i in range(n) if mask >> i & 1) for mask in terms)
            assert answer == value
        lattice.append(column)
    assert len(lattice) == 18 and inconsistent == 711
    comparison_cases = 0
    data_cases = 0
    for lhs, rhs in itertools.product(lattice, repeat=2):
        for t, ty in enumerate(orders):
            aa = [lhs[t] >= threshold for threshold in range(1,n)]
            bb = [rhs[t] >= threshold for threshold in range(1,n)]
            less = any(not a and b for a,b in zip(aa,bb))
            greater = any(a and not b for a,b in zip(aa,bb))
            equal = not less and not greater
            assert (less,equal,greater) == (lhs[t] < rhs[t],lhs[t] == rhs[t],lhs[t] > rhs[t])
            comparison_cases += 1
            for old, source in itertools.product(range(n), repeat=2):
                for high, inclusive in itertools.product((False,True), repeat=2):
                    take = greater if high else less
                    take |= equal and inclusive
                    output_bits = [(source if take else old) >= threshold for threshold in range(1,n)]
                    value = sum(output_bits)
                    assert value == (source if take else old)
                    data_cases += 1
    result = dict(n=n, strict_orders=len(orders), full_columns=len(columns),
                  lattice_columns=len(lattice), nonlattice_columns=inconsistent,
                  lattice_completion_and_witness_disagreements=0,
                  comparison_cases=comparison_cases, conditional_copy_cases=data_cases,
                  elapsed_seconds=time.monotonic()-start,
                  scope='Finite independent arithmetic checks, not a proof of A15')
    return result


if __name__ == '__main__':
    print(json.dumps(check(), indent=2))
