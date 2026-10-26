# n=5 model=out iset=I1 prefix14_class=5747
cmp P2, P3
cmovle S2, P3
cmovge S2, P2
cmovge P2, P3
mov S0, P1
mov S1, S2
cmp P0, P1
cmovl S0, P0
cmovge P1, P0
cmp S0, P2
mov P0, S0
cmovl P0, P2
cmovl P2, S0
mov P2, P0
