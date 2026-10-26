#!/usr/bin/env python3
"""Optional A15 normal forms: live values and genuinely non-lattice tags."""
import hashlib
import json
from pathlib import Path
import sys

import threshold_sat as base


class StrongEncoding(base.ThresholdEncoding):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        n, m = self.n, self.m
        for g in range(m):
            uses = [self.src[h][n+g] for h in range(g+1, m)]
            uses += [self.dst[h][n+g] for h in range(g+1, m)]
            uses += [self.cmp[j][s][n+g] for j in range(self.c) for s in range(2)]
            uses += [self.out[j][n+g] for j in range(n)]
            self.cl(*uses)
        # On all strict permutations, consistent threshold bits for each
        # subset automatically give a monotone table: each comparable pair
        # of subsets occurs in some nested threshold chain.
        assert len(self.types) == __import__('math').factorial(n)
        for s in range(2):
            witness = []
            observations = {}
            for t, masks in enumerate(self.masks):
                for r, mask in enumerate(masks):
                    observations.setdefault(mask, []).append(self.exception_rows[s][t][r])
            for bits in observations.values():
                w = self.new()
                witness.append(w)
                self.cl(-w, *bits)
                self.cl(-w, *[-b for b in bits])
            absent = (self.positions[s][-1] if self.positions is not None
                      else not any(self.ex[s]))
            self.cl(absent, *witness)
            # Unused arrays have one canonical assignment.
            for t, masks in enumerate(self.masks):
                for r, mask in enumerate(masks):
                    bit = self.exception_rows[s][t][r]
                    self.cl(self.neg(absent), bit if mask & 1 else -bit)


def main():
    base.ThresholdEncoding = StrongEncoding
    base.main()
    tag = sys.argv[sys.argv.index('--tag')+1]
    for suffix in ('.built.json', '.json'):
        path = Path(tag+suffix)
        record = json.loads(path.read_text())
        record.update(normal_forms=['Every data value is read or output',
                                    'Every selected exception is non-lattice on the strict orders',
                                    'Absent exception arrays equal input P0'],
                      strong_encoder_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
        path.write_text(json.dumps(record, indent=2)+'\n')


if __name__ == '__main__':
    main()
