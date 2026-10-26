# n=5 model=out iset=I1 prefix14_class=11920
cmp P3, P2
mov S1, P3
cmovle P3, P2
cmovl P2, S1
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
cmp P3, S1
cmovge P0, S1
cmovge S1, P3
mov S2, P1
cmovg P3, P0
mov S1, P3
