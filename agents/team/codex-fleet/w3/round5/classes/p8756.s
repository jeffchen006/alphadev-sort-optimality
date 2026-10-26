# n=5 model=out iset=I1 prefix14_class=8756
cmp P1, P3
mov S2, P3
cmovl S2, P1
cmovl P1, P3
cmp P2, P0
mov P3, P2
cmovle P3, P0
cmovl P0, P2
cmp P1, P3
cmovg P2, P1
cmovge P1, P3
cmovg P3, P2
cmp P0, S2
cmovle P2, P0
