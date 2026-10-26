# n=5 model=out iset=I1 prefix14_class=13060
mov S2, P3
cmp P1, S2
cmovl S2, P1
cmovg P3, P1
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp S2, P0
cmovle S1, S2
mov P1, P2
cmovl S2, P0
cmovl P0, S1
cmp P3, P2
