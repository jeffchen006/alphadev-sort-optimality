# n=5 model=out iset=I1 prefix14_class=8458
cmp P2, P3
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
mov S1, P1
cmp P0, S1
cmovl S1, P0
cmovle P0, P1
cmp P0, P2
mov S2, P2
cmovg P2, P0
mov P1, S1
cmovle S2, P0
cmp P3, S1
