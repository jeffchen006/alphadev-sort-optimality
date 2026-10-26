# n=5 model=out iset=I1 prefix14_class=13281
cmp P0, P2
cmovge S0, P0
mov S1, P3
cmovge P0, P2
cmovg P2, S0
cmp P3, P1
cmovl P3, P1
cmovge S1, P1
cmp S1, P0
cmovl P1, P0
cmovge P1, S1
cmovge S1, P0
cmp P2, P3
cmovle S2, P3
