# n=5 model=out iset=I1 prefix14_class=11012
cmp P3, P1
cmovge S2, P1
mov S0, P0
cmovg P1, P3
cmovge P3, S2
cmp P2, S0
cmovl S0, P2
cmovl P2, P0
cmp P2, P1
mov P0, P2
cmovl P2, P1
cmovl P1, P0
cmp P3, S0
cmovle P0, S0
