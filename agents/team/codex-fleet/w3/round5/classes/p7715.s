# n=5 model=out iset=I1 prefix14_class=7715
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovl P2, P0
cmovg P0, P2
mov S0, P3
cmp P3, P1
cmovl S0, P1
cmovge P3, P1
cmp P3, P2
cmovge P0, P3
cmovle P2, P3
cmp S0, S2
cmovge S1, S0
