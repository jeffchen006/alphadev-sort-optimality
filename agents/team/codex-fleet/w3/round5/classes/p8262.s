# n=5 model=out iset=I1 prefix14_class=8262
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
cmp P3, P2
cmovl S0, P2
cmovl P2, P3
cmovge S0, P3
mov P3, P2
cmp P2, P1
cmovge P2, P1
mov P2, P0
cmovge P1, P3
cmp S0, P0
