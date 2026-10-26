# n=5 model=out iset=I1 prefix14_class=1501
mov S2, P1
cmp P1, P3
mov S0, P2
cmovg P1, P3
cmovl S2, P3
cmp S0, P0
cmovle P2, P0
cmovl P0, S0
cmp P2, S2
cmovge S0, S2
cmovge S2, P2
cmovge P2, S0
mov P3, P1
cmp P0, P1
