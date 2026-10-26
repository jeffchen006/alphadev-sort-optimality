# n=5 model=out iset=I1 prefix14_class=2261
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovg S0, P0
mov P0, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, P0
cmovl P0, P2
cmp P2, P3
cmovl P2, P3
mov P2, S0
cmovl P3, P0
cmp S0, P1
