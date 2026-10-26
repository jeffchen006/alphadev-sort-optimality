# n=5 model=out iset=I1 prefix14_class=11213
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P3, P1
mov S2, P3
cmovle S2, P1
cmovg P3, P1
cmp P2, P0
mov S2, P0
