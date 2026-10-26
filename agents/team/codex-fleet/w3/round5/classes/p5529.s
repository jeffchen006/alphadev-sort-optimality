# n=5 model=out iset=I1 prefix14_class=5529
mov S1, P1
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
mov S2, P2
cmp S2, P3
cmovge P2, P3
cmovl S2, P3
mov S0, P0
cmp P0, P2
cmovge P0, P2
cmovl S0, P2
cmp S2, S1
cmovle P2, S1
