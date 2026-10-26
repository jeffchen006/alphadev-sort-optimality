# n=5 model=out iset=I1 prefix14_class=9441
cmp P0, P2
cmovl S1, P0
cmovle P0, P2
cmovge S1, P2
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovle S0, P3
cmp P1, S1
cmovle P2, S1
cmovle S1, P1
mov S1, P0
cmovl P1, P2
cmp S0, S1
