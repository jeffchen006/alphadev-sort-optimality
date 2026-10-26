# n=5 model=out iset=I1 prefix14_class=8076
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
mov S2, P2
cmovg P0, S1
cmp S2, P0
cmovle S2, P0
cmovg P2, P0
cmp P1, S0
mov P2, S0
