# n=5 model=out iset=I1 prefix14_class=8813
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovle P1, S2
cmp P2, P3
mov S2, P3
cmovl P3, P2
cmovg S2, P2
cmp P0, S2
cmovge S0, S2
cmovge S2, P0
cmovg P0, S0
mov P2, P3
cmp P2, P1
