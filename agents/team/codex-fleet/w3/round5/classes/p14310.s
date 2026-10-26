# n=5 model=out iset=I1 prefix14_class=14310
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovl P1, P2
mov P2, P0
cmp P0, P3
cmovl P2, P3
cmovge P0, P3
mov S2, P2
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp S1, P2
