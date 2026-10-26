# n=5 model=out iset=I1 prefix14_class=2305
cmp P3, P1
cmovl S2, P3
cmovl P3, P1
cmovge S2, P1
mov P1, P0
cmp P1, P2
cmovge P0, P2
cmovl P1, P2
cmovge P2, P1
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmp P0, S2
cmovge S0, S2
