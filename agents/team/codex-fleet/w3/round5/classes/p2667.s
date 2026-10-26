# n=5 model=out iset=I1 prefix14_class=2667
mov S0, P2
cmp P1, P3
cmovge S2, P1
cmovle S2, P3
cmovl P3, P1
cmp S0, P0
cmovge S0, P0
cmovg P0, P2
mov S1, P0
cmp S2, P0
cmovle S1, S2
cmovl S2, P0
mov S2, S1
mov P2, S0
