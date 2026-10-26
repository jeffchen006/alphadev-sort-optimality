# n=5 model=out iset=I1 prefix14_class=7660
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov S2, P2
cmovl P3, S1
cmp S2, P1
cmovl S2, P1
cmovle P1, P2
cmovge P2, P1
cmp P2, P0
cmovle P2, P0
cmovle P0, P1
mov P1, P2
cmp S2, P3
