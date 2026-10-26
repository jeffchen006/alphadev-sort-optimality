# n=5 model=out iset=I1 prefix14_class=2075
mov S1, P0
cmp P0, P1
cmovg P0, P1
cmovg P1, S1
mov S0, P2
cmp S0, P3
cmovl P2, P3
cmovge S0, P3
cmovge P3, P2
cmp P3, P1
cmovl P3, P1
cmovg P2, P1
mov P1, P2
cmp S0, P0
