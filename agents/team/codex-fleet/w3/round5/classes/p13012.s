# n=5 model=out iset=I1 prefix14_class=13012
mov S2, P3
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp S2, P0
cmovl S2, P0
cmovg P3, P0
cmovle P0, P3
cmp P1, P3
cmovl P0, P1
cmovg P3, P1
cmp S2, P2
cmovl P0, P2
