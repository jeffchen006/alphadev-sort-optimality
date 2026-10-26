# n=5 model=out iset=I1 prefix14_class=13992
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P1, P0
mov S2, P1
cmovle S2, P0
cmovge P1, P0
cmp P3, P2
mov S1, P3
