# n=5 model=out iset=I1 prefix14_class=1499
mov S2, P1
cmp P1, P2
mov S0, P0
cmovl S2, P2
cmovg P1, P2
cmp S0, P3
cmovle P0, P3
cmovl P3, S0
cmp P0, S2
cmovge S0, S2
cmovge S2, P0
cmovge P0, S0
mov P2, P1
cmp P3, P1
