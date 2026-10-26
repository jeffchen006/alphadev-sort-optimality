# n=5 model=out iset=I1 prefix14_class=2993
mov S1, P2
cmp P1, P2
cmovle P2, P1
cmovge S1, P1
cmp P3, P0
cmovge S2, P3
cmovge P3, P0
mov S0, S1
cmovg P0, S2
cmp S0, P0
cmovge S1, P0
mov P1, P2
cmovg P0, S0
mov P0, S1
