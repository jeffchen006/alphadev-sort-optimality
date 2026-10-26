# n=5 model=out iset=I1 prefix14_class=7223
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
cmovle S0, P1
cmp P3, P0
cmovge P1, P0
mov S2, S0
cmovge P0, P3
cmovge P3, P1
cmp P3, P2
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P0, S2
