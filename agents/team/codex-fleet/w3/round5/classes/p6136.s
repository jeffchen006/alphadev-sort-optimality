# n=5 model=out iset=I1 prefix14_class=6136
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovl P3, P1
cmp P2, P0
cmovge P1, P0
mov S2, S1
cmovge P0, P2
cmovge P2, P1
cmp S2, P0
cmovge S2, P0
mov S0, P3
cmovle S1, P0
cmp P2, P3
