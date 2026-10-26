# n=5 model=out iset=I1 prefix14_class=12159
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
mov S2, P1
cmp P1, P3
cmovge P1, P3
cmovle S2, P3
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
mov P3, P2
cmp P2, S2
