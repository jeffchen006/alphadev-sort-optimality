# n=5 model=out iset=I1 prefix14_class=4529
cmp P0, P2
cmovl S0, P2
cmovge S0, P0
cmovg P0, P2
cmovle P2, P0
mov S2, P1
cmp S2, P3
cmovl P1, P3
cmovg S2, P3
cmp P1, S0
cmovge P3, P1
cmovge P1, S0
cmovge S0, P3
cmp P0, S2
