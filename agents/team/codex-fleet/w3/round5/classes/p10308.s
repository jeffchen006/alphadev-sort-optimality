# n=5 model=out iset=I1 prefix14_class=10308
mov S2, P0
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmp P1, P3
cmovl P0, P3
cmovge P0, P1
cmovg P1, P3
cmp S2, P0
cmovge S0, P0
cmovge P0, S2
cmovg S2, S0
cmp P2, P1
cmovle P3, P2
