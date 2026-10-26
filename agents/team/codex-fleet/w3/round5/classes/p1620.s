# n=5 model=out iset=I1 prefix14_class=1620
mov S0, P3
cmp P3, P1
cmovge S0, P1
cmovl P3, P1
cmp P0, P2
mov P1, P2
cmovl P1, P0
cmovg P2, P0
cmp S0, P1
cmovl P0, P1
cmovle P1, S0
cmovl S0, P0
mov S2, P2
cmp P3, P2
