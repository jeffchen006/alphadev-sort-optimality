# n=5 model=out iset=I1 prefix14_class=12602
mov S0, P1
cmp P3, S0
cmovl S0, P3
cmovle P3, P1
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P2, S0
cmovle S2, S0
cmovl S0, P2
cmovl P2, S2
cmp P0, P3
cmovg S0, P3
