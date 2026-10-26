# n=5 model=out iset=I1 prefix14_class=12425
mov S0, P0
cmp S0, P3
cmovl S0, P3
cmovle P3, P0
cmp P2, P1
cmovl P0, P1
cmovl P1, P2
cmovl P2, P0
cmp P1, P3
cmovle P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P2, S0
cmovle P3, P2
