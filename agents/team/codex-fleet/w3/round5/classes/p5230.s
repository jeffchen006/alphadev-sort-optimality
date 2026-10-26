# n=5 model=out iset=I1 prefix14_class=5230
mov S1, P1
cmp P0, P2
mov S2, P0
cmovle S2, P2
cmovg P0, P2
cmp P3, S1
cmovl P1, P3
cmovle P3, S1
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovge S0, P1
mov P1, P3
cmp P3, S2
