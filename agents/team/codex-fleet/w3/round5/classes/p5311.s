# n=5 model=out iset=I1 prefix14_class=5311
cmp P0, P2
mov S2, P0
cmovge P0, P2
mov S0, P1
cmovge P2, S2
cmp P1, P3
cmovge P1, P3
cmovle S0, P3
cmp P1, P0
cmovge S1, P1
cmovl S1, P0
cmovl P0, P1
cmp S0, P2
cmovl P0, P2
