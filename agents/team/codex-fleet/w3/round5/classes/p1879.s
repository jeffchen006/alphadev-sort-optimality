# n=5 model=out iset=I1 prefix14_class=1879
mov S0, P2
mov S1, P1
cmp P0, S0
cmovle P2, P0
cmovl P0, S0
mov S2, P0
cmp P3, S1
cmovl S1, P3
cmovg P1, P3
cmp P1, S2
cmovle S2, P1
cmovl P1, P0
mov P1, S1
cmp P2, P1
