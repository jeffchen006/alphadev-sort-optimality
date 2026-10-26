# n=5 model=out iset=I1 prefix14_class=11553
mov S2, P1
cmp P2, S2
cmovl S2, P2
mov S0, S2
cmovg P1, P2
cmp P3, P0
cmovl P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P0, S2
cmovle S0, P0
cmovl P0, S2
cmovg S2, P0
mov S0, P3
