# n=5 model=out iset=I1 prefix14_class=5454
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovg S1, P0
mov S0, S1
cmp P3, P2
mov S2, P1
cmovge P0, P2
cmovge P2, P3
cmovg P3, P0
cmp P3, S1
cmovl S0, P3
cmovl P3, S1
cmp P1, P2
