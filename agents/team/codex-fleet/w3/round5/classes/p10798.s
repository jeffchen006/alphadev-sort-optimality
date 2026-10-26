# n=5 model=out iset=I1 prefix14_class=10798
cmp P0, P2
mov S2, P2
mov S1, P3
cmovl S2, P0
cmovg P2, P0
cmp S1, P1
cmovl P3, P1
cmovl P1, S1
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, S2
cmovl P0, S2
