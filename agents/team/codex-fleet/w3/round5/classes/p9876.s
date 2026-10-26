# n=5 model=out iset=I1 prefix14_class=9876
mov S2, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, S2
cmp P3, P0
cmovl S1, P0
cmovge S1, P3
cmovl P0, P3
mov S0, P2
cmp S1, S0
cmovge P2, S1
cmovge S1, S0
cmp P0, P1
cmovle S2, P1
