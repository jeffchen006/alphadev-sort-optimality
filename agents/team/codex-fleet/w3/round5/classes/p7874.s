# n=5 model=out iset=I1 prefix14_class=7874
cmp P0, P3
mov S2, P1
cmovle S0, P3
cmovge S0, P0
cmovl P3, P0
cmp S2, P2
cmovl P1, P2
cmovge S2, P2
cmp S2, P3
cmovge S1, S2
cmovge S2, P3
mov P0, P1
cmovg P3, S1
cmp S0, P0
