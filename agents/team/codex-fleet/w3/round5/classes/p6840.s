# n=5 model=out iset=I1 prefix14_class=6840
cmp P2, P0
cmovle S2, P0
mov S0, P3
cmovl P0, P2
cmovl P2, S2
cmp P1, P3
cmovl P3, P1
cmovl P1, S0
cmp P2, P1
cmovge S1, P1
cmovl S1, P2
cmovge P1, P2
cmp P3, P0
cmovg S2, P3
