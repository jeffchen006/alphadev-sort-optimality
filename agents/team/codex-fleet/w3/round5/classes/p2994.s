# n=5 model=out iset=I1 prefix14_class=2994
mov S2, P3
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
mov S0, S2
cmovg P0, S1
cmp S0, P0
cmovge S2, P0
mov P1, P3
cmovg P0, S0
mov P0, S2
