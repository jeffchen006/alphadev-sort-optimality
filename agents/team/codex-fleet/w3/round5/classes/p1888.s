# n=5 model=out iset=I1 prefix14_class=1888
cmp P3, P2
cmovle S0, P2
mov S2, P1
cmovl P2, P3
cmovle P3, S0
cmp P0, S2
cmovg P1, P0
cmovl S2, P0
mov S0, S2
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov P3, P1
