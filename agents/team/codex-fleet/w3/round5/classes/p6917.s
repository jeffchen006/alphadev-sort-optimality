# n=5 model=out iset=I1 prefix14_class=6917
mov S0, P1
cmp P0, P1
mov S2, P2
cmovl S0, P0
cmovle P0, P1
cmp S2, P3
cmovge S2, P3
cmovle P2, P3
cmp P2, P0
mov S1, S2
cmovle P1, P0
cmovl P0, P2
cmovl P2, P1
mov P3, P0
