# n=5 model=out iset=I1 prefix14_class=9455
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
cmovge S1, P3
cmovle S1, P2
cmovl P2, P3
mov S0, P1
cmp S1, P1
cmovg P1, S1
cmovl S0, S1
mov S0, P2
mov S1, P1
