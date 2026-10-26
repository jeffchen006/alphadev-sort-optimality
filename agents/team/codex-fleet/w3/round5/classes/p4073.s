# n=5 model=out iset=I1 prefix14_class=4073
cmp P0, P3
cmovl S1, P0
mov S2, P1
cmovl P0, P3
cmovl P3, S1
cmp P2, S2
cmovg P1, P2
cmovg P2, S2
cmp P2, P3
cmovge S0, P3
cmovle S0, P2
cmovle P2, P3
cmp P1, P0
mov P3, P1
