# n=5 model=out iset=I1 prefix14_class=667
mov S0, P2
cmp P3, S0
cmovle P2, P3
cmovl P3, S0
mov S1, P0
cmp P0, P1
cmovg P0, P1
cmovl S1, P1
mov S2, P3
cmp P3, S1
cmovl S2, S1
cmovle S1, P3
mov P1, P2
cmp P2, P0
