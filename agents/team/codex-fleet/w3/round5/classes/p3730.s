# n=5 model=out iset=I1 prefix14_class=3730
mov S2, P1
cmp S2, P0
mov S0, P2
cmovle P1, P0
cmovl P0, S2
cmp P3, S0
cmovg S0, P3
cmovg P3, P2
cmp P3, P0
mov P2, P0
cmovle P0, P3
mov S1, P1
cmovge P2, P3
mov P0, P2
