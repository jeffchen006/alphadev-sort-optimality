# n=5 model=out iset=I1 prefix14_class=2404
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovge P3, P1
cmp P2, P0
cmovge P1, P2
cmovl P1, P0
cmovle P0, P2
cmp P1, S0
cmovle P2, S0
cmovge P2, P1
cmovge P1, S0
mov P2, P3
cmp P0, P2
