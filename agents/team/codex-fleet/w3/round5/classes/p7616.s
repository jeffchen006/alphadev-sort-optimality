# n=5 model=out iset=I1 prefix14_class=7616
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovl P1, S2
mov S1, P3
cmp P2, P3
cmovl S1, P2
mov S0, S1
cmovg P3, P2
cmp S1, P1
cmovge S0, P1
cmovge P1, S1
mov S0, P3
cmp P0, S0
