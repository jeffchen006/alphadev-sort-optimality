# n=5 model=out iset=I1 prefix14_class=5188
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovl P3, S1
cmp P0, P1
mov S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
mov P1, P0
cmp P2, P1
