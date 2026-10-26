# n=5 model=out iset=I1 prefix14_class=12553
cmp P1, P3
mov S2, P0
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P0, P2
cmovge P0, P2
cmovle S2, P2
cmp P0, P3
mov P2, P0
cmovge P2, P3
mov P2, S2
cmovle P0, P3
cmovge P3, P0
