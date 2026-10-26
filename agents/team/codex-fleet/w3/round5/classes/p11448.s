# n=5 model=out iset=I1 prefix14_class=11448
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
mov S0, P3
cmp P0, P2
cmovge S2, P2
cmovg P2, P0
cmovg P0, S2
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmp P1, P2
cmovge S2, P1
