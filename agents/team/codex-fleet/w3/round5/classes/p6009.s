# n=5 model=out iset=I1 prefix14_class=6009
mov S0, P1
mov S2, P2
cmp S0, P3
cmovg P1, P3
cmovl S0, P3
cmp P0, S2
cmovl P2, P0
mov P3, P2
cmovge S2, P0
cmp S0, S2
cmovg P0, S2
cmovg S2, S0
cmovg S0, P0
cmp P1, P2
