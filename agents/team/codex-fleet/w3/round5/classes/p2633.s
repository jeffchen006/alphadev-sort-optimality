# n=5 model=out iset=I1 prefix14_class=2633
cmp P1, P2
cmovge S1, P2
mov S2, P0
cmovg P2, P1
cmovg P1, S1
cmp P3, S2
mov S0, P2
cmovge P0, P3
cmovl S2, P3
cmp P0, S0
cmovle P2, P0
cmovl P0, S0
mov S0, P1
cmp S2, P1
