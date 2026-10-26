# n=5 model=out iset=I1 prefix14_class=6639
mov S2, P2
cmp S2, P0
cmovge S2, P0
cmovge P0, P2
cmovle P2, P0
cmp P1, P3
mov S0, P1
cmovge P1, P3
cmovl S0, P3
cmp S0, P0
cmovle P0, S0
cmovge P2, S0
cmp S2, P1
cmovl P3, P1
