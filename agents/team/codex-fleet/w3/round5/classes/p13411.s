# n=5 model=out iset=I1 prefix14_class=13411
mov S0, P2
cmp P2, P0
cmovge P2, P0
mov S1, P1
cmovg P0, S0
cmp P3, P1
cmovle P1, P3
cmovge S1, P3
cmp P1, P2
cmovge S2, P2
cmovl S2, P1
cmovl P1, P2
cmp P0, S1
cmovl S0, P0
