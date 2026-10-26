# n=5 model=out iset=I1 prefix14_class=11406
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmovge S1, P2
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovge S0, P1
mov S2, S1
cmp P3, S0
cmovge P1, S0
cmovge S0, P3
mov P2, S0
cmovge P3, P1
