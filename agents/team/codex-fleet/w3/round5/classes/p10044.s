# n=5 model=out iset=I1 prefix14_class=10044
mov S2, P3
cmp P0, P3
cmovge P3, P0
cmovl S2, P0
cmp P2, P1
cmovle P0, P2
cmovge P0, P1
cmovl P2, P1
cmp P3, P2
mov S0, P0
cmovge P1, P2
cmovg P2, P3
cmovg P3, P1
cmp S2, S0
