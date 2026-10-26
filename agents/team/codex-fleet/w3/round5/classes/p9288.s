# n=5 model=out iset=I1 prefix14_class=9288
cmp P1, P0
mov S0, P0
cmovl S0, P1
cmovg P0, P1
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S1, S0
cmovl P2, S2
cmp P3, S1
cmovl S1, P3
cmovge S0, P3
mov P3, P2
cmp P0, P2
