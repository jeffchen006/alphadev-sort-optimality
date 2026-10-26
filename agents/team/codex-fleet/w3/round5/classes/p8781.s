# n=5 model=out iset=I1 prefix14_class=8781
cmp P2, P3
cmovl S2, P3
cmovl P3, P2
cmovl P2, S2
mov S0, P1
cmp P0, S0
cmovle P1, P0
cmovge S0, P0
cmp P2, S0
mov S1, P2
cmovg P2, S0
cmovge S0, S1
cmp P1, P3
cmovge P0, P1
