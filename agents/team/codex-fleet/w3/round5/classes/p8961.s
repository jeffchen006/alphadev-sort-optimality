# n=5 model=out iset=I1 prefix14_class=8961
cmp P3, P1
cmovl S0, P3
mov S2, P0
cmovle P3, P1
cmovl P1, S0
cmp S2, P2
cmovl P0, P2
cmovle P2, S2
cmp P3, P0
mov S2, P0
cmovl P0, P3
cmovge S2, P3
cmp P1, P2
mov P3, P1
