# n=5 model=out iset=I1 prefix14_class=11283
mov S1, P2
cmp P1, S1
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
cmovg P2, P3
cmovge P3, P0
cmovle P2, P0
cmp P1, P2
cmovl S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P3, S1
cmovle P0, S1
