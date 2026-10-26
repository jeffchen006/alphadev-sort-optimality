# n=5 model=out iset=I1 prefix14_class=2935
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmovle S2, P1
mov S1, P2
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P3, S2
mov P1, S2
