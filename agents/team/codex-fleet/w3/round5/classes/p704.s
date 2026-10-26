# n=5 model=out iset=I1 prefix14_class=704
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovge S0, P2
cmp P0, P1
mov P2, P0
mov S1, P3
cmovg P2, P1
cmovle P0, P1
cmp S1, P0
cmovl S1, P0
cmovle P0, P3
mov P1, P0
mov S1, P2
