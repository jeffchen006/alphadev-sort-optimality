# n=5 model=out iset=I1 prefix14_class=6522
mov S0, P1
cmp P1, P2
cmovg P1, P2
cmovg P2, S0
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
mov S1, P3
cmp P1, S1
