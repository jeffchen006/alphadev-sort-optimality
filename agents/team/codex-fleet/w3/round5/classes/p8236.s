# n=5 model=out iset=I1 prefix14_class=8236
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovl P2, S2
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
mov P1, P0
cmovl S0, P3
cmp P1, P2
