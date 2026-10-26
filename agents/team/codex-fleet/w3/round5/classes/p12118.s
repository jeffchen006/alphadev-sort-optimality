# n=5 model=out iset=I1 prefix14_class=12118
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
mov S2, P1
cmovg P0, S0
cmp P2, P1
cmovl P1, P2
cmovge S2, P2
cmp P3, P1
mov S1, P1
cmovle P1, P3
mov P1, P0
cmovge S1, P3
cmp S2, P0
