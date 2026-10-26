# n=5 model=out iset=I1 prefix14_class=13058
mov S2, P3
cmp P1, P3
cmovl S2, P1
cmovg P3, P1
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
cmp S2, P2
cmovle S0, S2
mov P1, P0
cmovle S2, P2
cmovl P2, S0
cmp P3, P0
