# n=5 model=out iset=I1 prefix14_class=11539
mov S2, P1
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
mov S1, P0
cmp P0, P3
cmovl S1, P3
cmovg P0, P3
cmp S2, P2
cmovge P0, S2
