# n=5 model=out iset=I1 prefix14_class=6716
mov S0, P0
cmp P1, P2
cmovge S1, P2
cmovge P2, P1
cmovge P1, S1
cmp S0, P3
cmovl S0, P3
cmovge P0, P3
cmovg P3, S0
cmp P3, P2
cmovl P3, P2
mov P3, P1
cmovge S0, P2
cmp P3, P0
