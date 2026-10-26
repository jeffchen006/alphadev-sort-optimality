# n=5 model=out iset=I1 prefix14_class=450
cmp P3, P2
mov S2, P2
cmovl P2, P3
cmovge S2, P3
mov P3, P1
cmp P1, P0
cmovg P1, P0
mov S0, P2
cmovg P0, P3
cmp P1, P2
cmovl S0, P1
mov S0, P0
cmovle P1, P2
cmp S0, S2
