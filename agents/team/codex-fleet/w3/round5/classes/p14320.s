# n=5 model=out iset=I1 prefix14_class=14320
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
mov S1, P3
cmovl P1, S0
cmp P0, S1
cmovg P3, P0
cmovg P0, S1
mov S2, P2
cmp P2, P0
cmovl S2, P0
cmovg P2, P0
cmp P1, P3
cmovle P0, P3
