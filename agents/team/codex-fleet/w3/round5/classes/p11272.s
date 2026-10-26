# n=5 model=out iset=I1 prefix14_class=11272
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
mov S2, P2
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovl S0, P0
cmp P2, P1
cmovge S2, P1
cmovle P2, P1
cmp P3, S0
mov P1, S0
