# n=5 model=out iset=I1 prefix14_class=11813
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
mov S2, P0
cmp P2, P0
cmovl S2, P2
cmovg P0, P2
mov P2, P1
cmp P3, P1
