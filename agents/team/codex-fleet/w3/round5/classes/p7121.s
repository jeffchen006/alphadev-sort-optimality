# n=5 model=out iset=I1 prefix14_class=7121
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
cmovge S2, P3
cmovl S2, P0
cmovle P0, P3
cmp P0, P1
mov P3, P0
cmovge P0, P1
mov P0, S2
cmovge P1, P3
cmp P2, P0
