# n=5 model=out iset=I1 prefix14_class=107
cmp P2, P3
cmovge S1, P2
cmovl S1, P3
mov S0, P1
cmovge P2, P3
cmp P0, P1
cmovge S0, P0
cmovl P1, P0
cmp P1, P2
mov S2, P2
cmovle P2, P1
cmovl P1, S2
mov P2, S0
mov P3, P1
