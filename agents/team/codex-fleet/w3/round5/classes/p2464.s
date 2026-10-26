# n=5 model=out iset=I1 prefix14_class=2464
cmp P3, P2
mov S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, P1
mov P2, P1
cmovge P1, P0
cmovge P0, P2
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmovge S0, P1
cmp P0, S2
cmovge P2, P0
