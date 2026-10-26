# n=5 model=out iset=I1 prefix14_class=12865
mov S2, P2
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
cmp P1, S2
mov P2, P1
cmovg P2, S2
cmovle P1, S2
cmp P0, P3
mov P2, P1
