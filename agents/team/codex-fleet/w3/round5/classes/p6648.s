# n=5 model=out iset=I1 prefix14_class=6648
cmp P3, P2
mov S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P0, P1
mov S1, P2
cmovge S0, P1
cmovg P1, P0
cmovg P0, S0
cmp S1, P1
cmovge S1, P1
cmovl P2, P1
cmp P3, P0
cmovl P1, S1
