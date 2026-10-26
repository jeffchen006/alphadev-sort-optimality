# n=5 model=out iset=I1 prefix14_class=9903
mov S2, P3
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
mov S1, P0
cmp S2, P2
cmovle S2, P2
cmovl P2, P3
cmp S2, P0
cmovl S1, S2
cmovl S2, P0
mov P3, P1
cmp P1, P2
