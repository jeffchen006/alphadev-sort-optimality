# n=5 model=out iset=I1 prefix14_class=6458
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovge P2, P1
cmovg P1, S2
cmp P1, P0
cmovge S2, P0
cmovg P0, P1
mov S0, S2
cmp P3, P2
