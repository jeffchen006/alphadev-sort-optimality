# n=5 model=out iset=I1 prefix14_class=14415
mov S1, P0
cmp P2, P0
cmovl P0, P2
mov S0, P1
cmovg S1, P2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovge P3, S0
cmp P1, S1
cmovl P2, S1
