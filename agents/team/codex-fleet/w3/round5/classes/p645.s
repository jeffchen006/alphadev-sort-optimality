# n=5 model=out iset=I1 prefix14_class=645
cmp P0, P2
mov S1, P0
cmovl P0, P2
cmovge S1, P2
mov P2, P3
cmp P3, P1
cmovge P2, P1
cmovle P3, P1
cmovg P1, P3
cmp P1, P0
cmovl P1, P0
cmovl P0, P3
cmp P2, S1
mov P3, S1
