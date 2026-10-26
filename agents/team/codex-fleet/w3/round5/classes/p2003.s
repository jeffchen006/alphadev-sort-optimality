# n=5 model=out iset=I1 prefix14_class=2003
cmp P1, P0
cmovge S1, P1
cmovl S1, P0
cmovg P1, P0
cmp P2, P3
mov S2, P3
cmovl S2, P2
cmovg P3, P2
cmovle P2, P3
cmp S1, P2
cmovg P3, S1
mov S0, S2
cmovl P2, S1
mov P3, P2
