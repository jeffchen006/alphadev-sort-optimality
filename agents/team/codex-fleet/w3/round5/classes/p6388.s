# n=5 model=out iset=I1 prefix14_class=6388
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
cmovl S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P0, P3
cmovle S1, P0
cmovg S1, P3
cmovge P3, P0
mov S0, P2
cmp P2, P1
