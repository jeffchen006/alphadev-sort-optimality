# n=5 model=out iset=I1 prefix14_class=7684
mov S2, P3
cmp P2, S2
cmovg P3, P2
cmovle S2, P2
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
mov S0, P1
cmp P1, S2
cmovl S0, S2
cmovl S2, P1
mov P1, P3
cmp P0, P1
