# n=5 model=out iset=I1 prefix14_class=8257
cmp P2, P0
cmovle S1, P2
cmovge S1, P0
cmovl P2, P0
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmovge P1, S0
cmp P1, S1
cmovge P0, S1
cmovl P0, P1
cmovg S1, P1
mov P0, S1
mov S2, P3
