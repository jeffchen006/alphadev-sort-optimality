# n=5 model=out iset=I1 prefix14_class=11258
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovge S2, P1
mov P1, P2
cmp P3, P1
cmovg P1, P3
cmovge P3, P2
mov P2, P0
cmp P2, P1
cmovle P2, P1
cmovl P1, P0
cmp S2, P3
cmovg P0, P3
