# n=5 model=out iset=I1 prefix14_class=5527
mov S1, P1
cmp S1, P0
cmovl P1, P0
mov S2, P2
cmovl P0, S1
cmp S2, P3
cmovl S2, P3
cmovge P2, P3
mov S0, P2
cmp P2, P0
cmovle S0, P0
cmovge P2, P0
cmp S2, P1
cmovl P2, P1
