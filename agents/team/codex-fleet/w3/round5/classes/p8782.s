# n=5 model=out iset=I1 prefix14_class=8782
cmp P1, P3
cmovl S2, P3
cmovl P3, P1
cmovl P1, S2
mov S0, P2
cmp P0, S0
mov S1, P1
cmovle P2, P0
cmovge S0, P0
cmp P1, S0
cmovg P1, S0
cmovge S0, S1
cmp P2, P3
cmovge P0, P2
