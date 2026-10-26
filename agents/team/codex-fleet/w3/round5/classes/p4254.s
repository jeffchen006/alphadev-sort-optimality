# n=5 model=out iset=I1 prefix14_class=4254
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovl S1, P2
mov P2, P1
cmp P3, P1
cmovge P2, P3
cmovge P3, P1
cmp S1, P3
cmovle P1, P3
cmovl P3, S1
cmovg P1, S1
cmp P0, P2
cmovge S1, P0
