# n=5 model=out iset=I1 prefix14_class=5541
mov S0, P3
cmp P2, P1
cmovg S1, P2
cmovge P2, P1
cmovle S1, P1
cmp P3, P0
cmovl P3, P0
cmovl P0, S0
cmp P2, P0
mov P1, P3
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
cmp P3, S1
