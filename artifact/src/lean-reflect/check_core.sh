#!/bin/sh
# Check that SortProof/* is a byte copy of agents/lean/frozen/v2 (the one machine definition).
cd "$(dirname "$0")" && grep -E '\./SortProof(\.lean|/)' ../lean/frozen/v2/SHA256SUMS | sha256sum -c -
