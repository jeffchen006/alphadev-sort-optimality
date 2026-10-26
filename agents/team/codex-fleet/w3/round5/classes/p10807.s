# n=5 model=out iset=I1 prefix14_class=10807
mov S0, P3
cmp P1, P3
cmovg P3, P1
cmovl S0, P1
cmp P0, P2
mov S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P2, S0
cmovl S2, S0
