# n=5 model=out iset=I1 prefix14_class=1042
mov S0, P0
cmp S0, P3
cmovl P0, P3
mov S1, P1
cmovl P3, S0
cmp S1, P2
cmovge S1, P2
cmovge P2, P1
cmp P0, P2
cmovge S2, P0
cmovle S2, P2
cmovge P0, P2
cmp S1, P3
cmovge S2, S1
