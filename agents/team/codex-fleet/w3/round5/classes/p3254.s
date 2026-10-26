# n=5 model=out iset=I1 prefix14_class=3254
cmp P1, P0
cmovl S0, P0
cmovge S0, P1
mov S2, P3
cmovle P0, P1
mov P1, P0
cmp P2, S2
cmovge S2, P2
cmovg P2, P3
cmp P1, P2
cmovl P0, P2
cmovge P1, P2
mov P1, S2
mov P2, P0
