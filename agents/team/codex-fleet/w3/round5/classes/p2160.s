# n=5 model=out iset=I1 prefix14_class=2160
mov S1, P0
cmp S1, P2
cmovle P0, P2
cmovge S1, P2
mov P2, P3
cmp P1, P3
cmovl P3, P1
cmovl P1, P2
mov S0, P0
cmp P1, S0
cmovg P0, P1
cmovl S0, P1
cmp P3, S1
cmovl P1, S1
