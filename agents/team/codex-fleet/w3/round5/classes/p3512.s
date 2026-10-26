# n=5 model=out iset=I1 prefix14_class=3512
cmp P0, P1
cmovge S0, P1
mov S1, P3
cmovge P1, P0
cmovg P0, S0
cmp P2, S1
cmovl S1, P2
mov S2, S1
cmovl P2, P3
mov P3, P1
cmp S1, P0
cmovle S1, P0
cmovge S2, P0
cmp P2, P1
