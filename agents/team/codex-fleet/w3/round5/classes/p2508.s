# n=5 model=out iset=I1 prefix14_class=2508
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
mov S0, P0
cmovg P2, S1
cmp S0, P3
cmovl S0, P3
cmovg P0, P3
cmp P1, P2
mov S0, P1
