# n=5 model=out iset=I1 prefix14_class=9715
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmovge P1, S2
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmovge S0, P2
mov S1, P3
cmp S0, S1
cmovge S1, S0
cmovle P3, S0
cmp P1, P0
cmovl P2, P1
