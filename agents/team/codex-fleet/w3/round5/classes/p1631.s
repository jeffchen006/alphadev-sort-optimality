# n=5 model=out iset=I1 prefix14_class=1631
cmp P2, P0
mov S2, P1
cmovge S0, P2
cmovg P2, P0
cmovl S0, P0
cmp P3, P1
cmovl S2, P3
cmovge P1, P3
cmp P2, S2
cmovle P3, P2
cmovg P3, S2
cmovl P2, S2
mov S1, S0
cmp S0, P1
