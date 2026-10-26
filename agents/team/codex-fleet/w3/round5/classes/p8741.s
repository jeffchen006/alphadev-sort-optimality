# n=5 model=out iset=I1 prefix14_class=8741
mov S2, P2
cmp P2, P1
cmovge S2, P1
cmovle P2, P1
cmp P3, P0
mov P1, P0
cmovl P0, P3
cmovg P1, P3
mov P3, P2
cmp P1, P3
cmovle P3, P1
cmovl P1, P2
mov P1, P0
cmovl P2, P3
