# n=5 model=out iset=I1 prefix14_class=8539
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovle S0, P3
mov P3, P1
cmp P2, P1
cmovge P3, P2
cmovle P1, P2
mov P3, P0
cmp P0, S0
