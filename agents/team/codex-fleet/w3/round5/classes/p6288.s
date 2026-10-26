# n=5 model=out iset=I1 prefix14_class=6288
cmp P0, P1
cmovge S0, P1
mov S2, P3
cmovl S0, P0
cmovge P1, P0
cmp P2, P3
cmovg P3, P2
cmovge P2, S2
mov S1, P3
cmp S1, P1
cmovl S1, P1
cmovle P1, P3
mov P3, P2
mov S1, P1
