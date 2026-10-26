# n=5 model=out iset=I1 prefix14_class=7612
cmp P2, P1
cmovl S0, P2
cmovl P2, P1
cmovl P1, S0
mov S1, P3
cmp P0, P3
cmovle S1, P0
cmovge P3, P0
cmp P1, S1
mov S2, S1
cmovl S2, P1
cmovg S1, P1
cmp P3, P2
cmovge S2, P2
