# n=5 model=out iset=I1 prefix14_class=14091
cmp P1, P2
mov S1, P1
cmovl P1, P2
cmovl P2, S1
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovl S1, P0
cmp P1, P3
mov S2, P2
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
mov P1, P3
