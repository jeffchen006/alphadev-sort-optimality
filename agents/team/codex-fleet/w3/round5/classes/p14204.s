# n=5 model=out iset=I1 prefix14_class=14204
cmp P2, P3
cmovge S2, P2
cmovl S2, P3
mov S1, S2
cmovg P2, P3
cmp P0, P1
cmovge P3, P1
cmovg P1, P0
cmovge P0, P3
cmp S2, P1
cmovle S2, P1
mov S0, P2
cmovge S1, P1
cmovl P1, S1
