# n=5 model=out iset=I1 prefix14_class=1415
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovg P3, S1
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
mov S0, P0
cmp P0, P3
cmovge S0, P3
cmovl P0, P3
cmp P2, P1
mov S2, S0
