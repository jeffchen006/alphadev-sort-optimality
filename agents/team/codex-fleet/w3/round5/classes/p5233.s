# n=5 model=out iset=I1 prefix14_class=5233
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovg P1, P2
mov S0, P1
mov S2, P0
cmp P3, S2
mov P2, S1
cmovl P0, P3
cmovle P3, S2
cmp S0, P0
cmovge P1, P0
cmovl S0, P0
mov P1, S0
