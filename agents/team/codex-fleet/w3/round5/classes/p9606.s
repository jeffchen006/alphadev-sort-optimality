# n=5 model=out iset=I1 prefix14_class=9606
cmp P0, P1
mov S0, P1
cmovle S0, P0
cmovge P1, P0
cmp P3, P2
cmovge S2, P2
mov P0, P1
cmovg P2, P3
cmovge P3, S2
cmp P1, P2
cmovge P1, P2
cmovge P2, P0
cmp S0, P3
cmovle S2, S0
