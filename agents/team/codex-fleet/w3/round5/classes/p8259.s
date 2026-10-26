# n=5 model=out iset=I1 prefix14_class=8259
cmp P2, P0
cmovle S1, P2
cmovg S1, P0
cmovl P2, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
cmovge P1, P0
cmp P1, S1
cmovge S0, S1
cmovg S1, P1
cmovl S0, P1
mov S0, S1
cmp P2, P3
