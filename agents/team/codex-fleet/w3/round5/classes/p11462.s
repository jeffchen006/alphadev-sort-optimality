# n=5 model=out iset=I1 prefix14_class=11462
mov S0, P0
cmp S0, P2
cmovl S0, P2
cmovg P0, P2
cmp P1, P3
mov P2, P3
cmovl P2, P1
cmovge P3, P1
mov P1, P2
cmp P0, P2
cmovge P2, P0
cmovl P1, P0
cmp S0, P3
cmovge P0, P3
