# n=5 model=out iset=I1 prefix14_class=584
cmp P1, P3
mov S0, P0
cmovl S1, P1
cmovle P1, P3
cmovge S1, P3
cmovg P3, P1
cmp S0, P2
cmovge S0, P2
cmovge P2, P0
cmp P2, P1
cmovg P3, P2
mov S2, S0
cmovl P1, P2
cmp S1, S0
