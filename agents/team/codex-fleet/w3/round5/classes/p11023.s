# n=5 model=out iset=I1 prefix14_class=11023
mov S2, P2
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P0, S2
cmovg P2, P0
cmovl S2, P0
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, S2
cmovle S1, S2
