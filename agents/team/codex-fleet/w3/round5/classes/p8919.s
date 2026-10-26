# n=5 model=out iset=I1 prefix14_class=8919
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmovl P2, S2
mov S1, P3
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmp P2, P0
cmovl P3, P2
cmovge P3, P0
cmovle P2, P0
mov P2, S1
cmp P1, P2
