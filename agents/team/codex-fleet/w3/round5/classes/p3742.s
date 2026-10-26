# n=5 model=out iset=I1 prefix14_class=3742
mov S0, P2
cmp P3, S0
cmovge P2, P3
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
mov S2, S0
cmovge P1, S1
cmp P1, S0
cmovle S2, P1
cmovg S0, P1
cmp P3, P0
