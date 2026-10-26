# n=5 model=out iset=I1 prefix14_class=1849
mov S0, P3
mov S2, P1
cmp P0, P1
cmovle S2, P0
cmovge P1, P0
cmp P2, S0
cmovge P3, P2
cmovge P2, S0
mov S1, P3
cmp S1, P1
cmovl S1, P1
cmovl P1, P3
cmp S2, P2
cmovge S0, P2
