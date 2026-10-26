# n=5 model=out iset=I1 prefix14_class=14230
mov S2, P0
cmp P3, P1
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P2, P0
cmovle P0, P2
cmovge S2, P2
mov P2, S2
cmp P3, S2
cmovl S2, P3
cmovg P2, P3
cmp P1, P0
cmovle S0, P0
