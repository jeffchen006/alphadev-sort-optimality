# n=5 model=out iset=I1 prefix14_class=58
mov S1, P2
cmp P1, S1
cmovl P2, P1
cmovle P1, S1
mov S2, P0
cmp P3, S2
cmovg P0, P3
mov S1, P0
cmovl S2, P3
mov S0, P2
cmp S0, S2
cmovge S0, S2
cmovge S2, P2
cmovl P2, S2
