# n=5 model=out iset=I1 prefix14_class=4461
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovl P1, P2
cmp S1, P3
cmovle S2, S1
mov P2, P0
cmovl S1, P3
cmovle P3, S2
cmp P2, P1
