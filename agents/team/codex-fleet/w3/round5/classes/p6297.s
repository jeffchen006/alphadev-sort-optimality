# n=5 model=out iset=I1 prefix14_class=6297
mov S0, P3
cmp P2, P3
mov S1, P0
cmovl S0, P2
cmovge P3, P2
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmp P1, P3
mov P0, P3
cmovle P0, P1
cmovg P3, P1
cmp S0, S1
cmovge P2, S0
