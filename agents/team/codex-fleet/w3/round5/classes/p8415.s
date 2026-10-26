# n=5 model=out iset=I1 prefix14_class=8415
mov S1, P3
cmp S1, P1
cmovge S1, P1
mov S0, P0
cmovg P1, P3
cmp P2, S0
cmovge P0, P2
cmovl S0, P2
cmp P1, P0
mov P2, P0
cmovge P0, P1
cmovge P1, P2
cmp S1, S0
cmovl P2, P1
