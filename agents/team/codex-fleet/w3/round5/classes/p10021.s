# n=5 model=out iset=I1 prefix14_class=10021
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
mov S1, P1
cmovl P2, S0
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmovg P1, S1
cmp S1, P2
mov S2, P0
cmovl P1, P2
cmovge S1, P2
cmovl P2, S1
