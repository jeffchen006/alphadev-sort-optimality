# n=5 model=out iset=I1 prefix14_class=2019
cmp P2, P1
mov S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovge S2, P0
mov P0, P3
cmp P1, P0
cmovg P3, P1
cmovg P1, P0
cmp P2, S2
cmovl S0, S2
