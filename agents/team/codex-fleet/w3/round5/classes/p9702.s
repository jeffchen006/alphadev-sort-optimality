# n=5 model=out iset=I1 prefix14_class=9702
cmp P2, P1
cmovle S0, P1
cmovge S0, P2
cmovg P2, P1
mov S2, P0
cmp P3, P0
cmovg P0, P3
cmovg P3, S2
mov P1, P3
cmp P0, S0
cmovl S1, S0
cmovl S0, P0
cmovl P0, S1
cmp P3, P2
