# n=5 model=out iset=I1 prefix14_class=6999
mov S1, P3
cmp P2, S1
cmovge P3, P2
mov S2, P1
cmovl S1, P2
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmp S1, P0
cmovl P2, S1
cmovge P2, P0
cmovle S1, P0
cmp S2, P3
cmovl S0, S2
