# n=5 model=out iset=I1 prefix14_class=3947
cmp P0, P3
mov S2, P3
cmovge S2, P0
cmovle P3, P0
mov P0, P2
cmp P2, P1
cmovl P0, P1
cmovle P1, P2
mov S1, P1
cmp P3, S1
cmovge P1, P3
cmovl S1, P3
cmp S2, P0
cmovle P2, S2
