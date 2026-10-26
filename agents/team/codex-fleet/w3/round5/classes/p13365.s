# n=5 model=out iset=I1 prefix14_class=13365
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
mov S1, P1
cmp P0, P1
cmovg P1, P0
cmovl S1, P0
cmp S1, P3
cmovge S2, P3
cmovle S2, S1
cmovg P3, S1
cmp P1, P2
cmovle P0, P1
