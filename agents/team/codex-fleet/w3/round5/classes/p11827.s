# n=5 model=out iset=I1 prefix14_class=11827
cmp P2, P1
mov S0, P1
cmovl P1, P2
cmovl P2, S0
mov S1, P0
cmp P3, P0
cmovge S1, P3
cmovl P0, P3
mov S2, P2
cmp S2, S1
cmovge P2, S1
cmovle S2, S1
cmp P0, P1
cmovge S2, P1
