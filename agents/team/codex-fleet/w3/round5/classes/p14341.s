# n=5 model=out iset=I1 prefix14_class=14341
mov S0, P2
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
mov P2, S0
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P3, S0
cmovg P2, P3
cmovl S0, P3
mov P3, P1
cmp P0, P3
