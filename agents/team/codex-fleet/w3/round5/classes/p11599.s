# n=5 model=out iset=I1 prefix14_class=11599
mov S1, P2
cmp S1, P0
cmovl S1, P0
cmovg P2, P0
cmp P1, P3
mov P0, P1
cmovle P0, P3
cmovle P3, P1
cmovge P1, P3
cmp P2, P3
cmovl P3, P2
mov P3, S1
cmovl P2, P1
cmp S1, P0
