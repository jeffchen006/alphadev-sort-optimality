# n=5 model=out iset=I1 prefix14_class=3993
mov S0, P0
cmp P0, P2
cmovle P0, P2
mov S2, P1
cmovg S0, P2
cmp S2, P3
cmovge S2, P3
mov P2, S2
cmovg P3, P1
cmp S2, S0
cmovge S2, S0
mov S2, P0
cmovg S0, P2
cmp P3, S2
