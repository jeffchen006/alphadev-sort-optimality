# n=5 model=out iset=I1 prefix14_class=12760
cmp P0, P1
mov S2, P0
cmovge P0, P1
cmovl S2, P1
cmovl P1, P0
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P2, P1
cmovge P0, P2
cmovge P2, P1
mov P2, S2
cmp P3, S2
