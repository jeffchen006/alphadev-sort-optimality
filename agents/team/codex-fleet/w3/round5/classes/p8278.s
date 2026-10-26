# n=5 model=out iset=I1 prefix14_class=8278
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
mov S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, S0
cmovge S2, P0
cmovge P0, S0
cmovg S0, S2
mov P0, P3
cmp P2, P0
