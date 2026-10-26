# n=5 model=out iset=I1 prefix14_class=14121
cmp P2, P0
mov S1, P1
mov S2, P2
cmovge S2, P0
cmovge P0, P2
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp P0, P3
cmovl P2, P0
cmovl P0, P3
cmovl P3, P2
mov P0, P1
cmp S2, P1
