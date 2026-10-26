# n=5 model=out iset=I1 prefix14_class=7687
mov S0, P1
cmp P0, P1
cmovg P1, P0
cmovl S0, P0
mov P0, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmp S0, P2
cmovle S2, S0
cmovle S0, P2
cmovl P2, S2
cmp P3, P1
cmovl S2, P1
