# n=5 model=out iset=I1 prefix14_class=2677
mov S1, P1
cmp P2, P1
cmovge S1, P2
cmovle P1, P2
cmp P0, P3
cmovge P2, P0
cmovle P2, P3
cmovge P0, P3
cmovg P3, P2
cmp S1, P2
cmovle P2, S1
cmovl S1, P3
cmp P1, P0
mov S1, P1
