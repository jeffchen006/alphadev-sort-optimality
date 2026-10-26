# n=5 model=out iset=I1 prefix14_class=9440
mov S0, P1
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
cmovl P0, P2
cmp S0, P3
cmovg P1, P3
cmovle S0, P3
mov S2, P0
cmp P1, S1
cmovle P2, S1
cmovl S1, P1
cmovl P1, P2
cmp S0, S2
