# n=5 model=out iset=I1 prefix14_class=11325
mov S1, P1
cmp P3, P2
mov S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, S1
cmovg P1, P0
cmovg P0, S1
cmp P1, P3
cmovl S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
cmovle S1, P2
