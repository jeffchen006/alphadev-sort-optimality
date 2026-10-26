# n=5 model=out iset=I1 prefix14_class=13207
cmp P3, P0
mov S0, P2
cmovl S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, P2
cmovl P2, P1
cmovle P1, S0
cmovle S0, P2
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmp P1, P3
cmovg P2, P1
