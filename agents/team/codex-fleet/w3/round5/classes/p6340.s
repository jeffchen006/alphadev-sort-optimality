# n=5 model=out iset=I1 prefix14_class=6340
mov S2, P3
mov S0, P1
cmp S2, P2
cmovge S2, P2
cmovge P2, P3
cmp S0, P0
cmovl P1, P0
cmovle P0, S0
mov S1, P1
cmp P1, P2
cmovg S1, P2
cmovl P1, P2
mov P1, S1
cmp S2, P0
