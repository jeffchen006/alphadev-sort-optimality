# n=5 model=out iset=I1 prefix14_class=3260
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
mov S1, P2
cmovge P1, P0
cmovle P0, P1
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmp P1, P3
cmovle P0, P3
cmovg P1, P3
mov P3, S0
cmp S1, P3
