# n=5 model=out iset=I1 prefix14_class=13090
cmp P3, P0
cmovge S2, P3
mov S0, P1
cmovg P3, P0
cmovge P0, S2
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
mov P1, P2
cmp P3, P1
cmovg P1, P3
cmovl P2, P3
mov P2, S0
cmp S0, P0
