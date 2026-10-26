# n=5 model=out iset=I1 prefix14_class=5185
mov S1, P2
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
mov P0, P3
cmp P2, P0
