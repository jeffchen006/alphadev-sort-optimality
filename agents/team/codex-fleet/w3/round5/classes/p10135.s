# n=5 model=out iset=I1 prefix14_class=10135
cmp P1, P0
mov S1, P1
cmovge S1, P0
cmovle P1, P0
mov P0, P3
cmp P0, P2
cmovg P0, P2
cmovg P2, P3
cmp P1, P2
mov P3, P2
cmovg P3, P1
cmovl P2, P1
mov P3, P0
cmovg P1, P2
