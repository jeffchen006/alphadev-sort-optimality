# n=5 model=out iset=I1 prefix14_class=5277
cmp P2, P3
mov S0, P2
cmovge P2, P3
cmovl S0, P3
mov P3, P1
cmp P1, P0
cmovge P1, P0
cmovle P3, P0
mov P0, P1
cmp P2, P1
cmovle P0, P2
cmovl P2, P1
cmp P3, S0
mov P1, S0
