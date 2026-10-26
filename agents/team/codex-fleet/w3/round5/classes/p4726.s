# n=5 model=out iset=I1 prefix14_class=4726
cmp P3, P1
mov S0, P3
mov S2, P0
cmovge S0, P1
cmovl P3, P1
cmp P2, P0
cmovg P0, P2
cmovge P2, S2
mov P1, P2
cmp S0, P1
cmovge P1, S0
cmovge S0, P2
cmp P3, P0
cmovge P2, P0
