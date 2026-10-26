# n=5 model=out iset=I1 prefix14_class=67
cmp P1, P0
mov S1, P1
cmovl P1, P0
mov S0, P2
cmovge S1, P0
cmp P3, P2
cmovle S0, P3
cmovge P2, P3
mov S2, P1
cmovge P3, S0
cmp S0, S1
cmovge S0, S1
cmovge S1, P3
cmp S2, P2
