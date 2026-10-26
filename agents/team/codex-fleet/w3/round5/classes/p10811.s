# n=5 model=out iset=I1 prefix14_class=10811
mov S2, P2
cmp P1, S2
cmovg P2, P1
cmovle S2, P1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovge S1, P3
cmp P2, S1
cmovl P3, P2
cmovl P2, S1
cmovl S1, P3
mov P2, S2
cmp P0, S2
