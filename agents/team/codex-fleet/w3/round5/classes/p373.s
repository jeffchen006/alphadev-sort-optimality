# n=5 model=out iset=I1 prefix14_class=373
cmp P0, P3
mov S1, P2
mov S0, P0
cmovg S0, P3
cmovl P0, P3
cmovle P3, S0
cmp S1, P1
cmovl S1, P1
cmovge P2, P1
cmp P2, P3
cmovl S0, P2
cmovl P2, P3
cmp S1, P0
mov P3, P0
