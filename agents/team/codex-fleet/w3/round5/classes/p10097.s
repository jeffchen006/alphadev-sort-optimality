# n=5 model=out iset=I1 prefix14_class=10097
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
cmovge P0, S0
mov S2, P2
cmp S1, P0
cmovl P1, S1
cmovl S1, P0
cmovl P0, P1
cmp P3, P2
