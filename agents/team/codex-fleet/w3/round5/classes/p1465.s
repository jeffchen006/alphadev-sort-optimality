# n=5 model=out iset=I1 prefix14_class=1465
mov S0, P2
cmp P2, P1
cmovge S0, P1
mov S2, P0
cmovg P1, P2
cmp S2, P3
mov P2, P1
cmovl S2, P3
cmovle P3, P0
cmp P1, S2
mov S1, S0
cmovge P1, S2
cmovl P2, S2
mov P2, P1
