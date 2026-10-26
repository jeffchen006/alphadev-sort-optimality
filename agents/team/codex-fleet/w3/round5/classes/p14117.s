# n=5 model=out iset=I1 prefix14_class=14117
mov S2, P2
mov S0, P3
cmp P0, P2
cmovl S2, P0
cmovle P0, P2
cmp P1, S0
cmovle S0, P1
cmovg P3, P1
cmp P3, P0
mov P2, S2
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
mov P3, P0
