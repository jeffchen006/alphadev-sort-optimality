# n=5 model=out iset=I1 prefix14_class=5833
cmp P2, P3
cmovge S1, P3
cmovle S1, P2
cmovge P3, P2
cmp P0, P1
mov P2, P0
cmovl P0, P1
cmovle P1, P2
cmp S1, P1
cmovl S0, S1
cmovle S1, P1
cmovge S0, P1
cmp P0, P3
cmovle P1, P0
