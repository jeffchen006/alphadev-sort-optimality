# n=5 model=out iset=I1 prefix14_class=7788
mov S1, P0
mov S0, P1
cmp P0, P2
cmovl S1, P2
cmovge P0, P2
cmp S0, P3
cmovl S0, P3
cmovge P1, P3
mov P3, P1
cmp P0, P3
cmovle P3, P0
cmovg P1, P0
cmp S1, S0
cmovl P3, S1
