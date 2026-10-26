# n=5 model=out iset=I1 prefix14_class=6218
cmp P0, P3
mov S1, P1
mov S0, P0
cmovl P0, P3
cmovge S0, P3
cmp P2, S1
cmovle S1, P2
mov S2, P0
cmovge P1, P2
cmp S2, P1
cmovge P0, P1
cmovl S2, P1
cmp S0, S1
cmovge P3, S1
