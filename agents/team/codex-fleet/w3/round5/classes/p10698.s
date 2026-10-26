# n=5 model=out iset=I1 prefix14_class=10698
cmp P0, P2
mov S2, P0
cmovg P0, P2
mov S1, P1
cmovl S2, P2
cmp P3, P1
cmovle S1, P3
cmovge P1, P3
cmp P1, S2
cmovl P2, S2
cmovl S2, P1
cmovl P1, P2
cmp P0, S1
mov P1, P0
