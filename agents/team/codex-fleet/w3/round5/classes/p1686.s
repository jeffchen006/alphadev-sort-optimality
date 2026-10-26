# n=5 model=out iset=I1 prefix14_class=1686
cmp P3, P0
cmovge S1, P3
cmovl S1, P0
cmovl P0, P3
cmp P1, P2
cmovl P3, P1
cmovl P1, P2
cmovge P3, P2
cmovle P2, P3
cmp P0, P3
cmovge P3, P0
cmovle P2, P0
cmp S1, P1
mov P2, P1
