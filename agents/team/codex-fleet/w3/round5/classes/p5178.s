# n=5 model=out iset=I1 prefix14_class=5178
mov S1, P0
cmp S1, P1
cmovl P0, P1
cmovle P1, S1
cmp P3, P2
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P2, P1
cmovge S1, P2
cmovge P2, P1
mov P2, P0
cmovg P1, S1
cmp P3, P0
