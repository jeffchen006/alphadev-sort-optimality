# n=5 model=out iset=I1 prefix14_class=2290
mov S2, P2
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
cmovl P3, P0
mov S0, P3
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
mov P1, P2
cmp S2, S0
cmovge S0, S2
cmovl P3, S2
mov P0, P3
