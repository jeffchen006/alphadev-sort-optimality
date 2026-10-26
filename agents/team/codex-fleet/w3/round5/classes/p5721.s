# n=5 model=out iset=I1 prefix14_class=5721
mov S0, P1
mov S1, P0
cmp P3, P0
cmovg P0, P3
cmovle S1, P3
cmp P2, S0
cmovge S0, P2
cmovg P2, P1
mov S2, P2
cmp P2, S1
cmovge P2, S1
cmovge S1, S2
cmp P0, S0
cmovge P1, S0
