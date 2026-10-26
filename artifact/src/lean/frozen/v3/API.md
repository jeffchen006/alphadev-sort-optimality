# SortProof frozen API v3 (2026-10-24)

v3 = v2 (all 12 files byte-identical) + `L5Strict.lean`: `l5_sim` (snapshots = final cells for EVERY initial state),
`l5_len`, `l5_iset`, `l5_strict_int` (StrictCorrect -> StrictSnap), `l5_strict` (XCorrect -> XSnap, theory CERT_OBLIGATIONS),
`mm_lower_bound_strict` (H: forall p o, |p| <= K -> not XSnap) and `mm_lower_bound_strict_int`. Same usage rules as v1/API.md.
