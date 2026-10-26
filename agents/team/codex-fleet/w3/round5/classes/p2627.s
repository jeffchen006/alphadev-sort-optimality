# n=5 model=out iset=I1 prefix14_class=2627
mov S1, P3
cmp P2, P3
cmovg P3, P2
mov S2, P1
cmovg P2, S1
cmp P0, S2
cmovg P1, P0
cmovl S2, P0
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P2, S2
cmovl S0, S2
