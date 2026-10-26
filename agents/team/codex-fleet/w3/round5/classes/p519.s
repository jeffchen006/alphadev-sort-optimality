# n=5 model=out iset=I1 prefix14_class=519
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
cmovg P1, P0
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
mov S0, P1
mov S2, S1
cmp P2, S2
cmovg S2, P2
cmovle S1, P2
cmovl P2, S2
