# n=5 model=out iset=I1 prefix14_class=8547
mov S2, P0
cmp S2, P3
cmovle P0, P3
cmovle P3, S2
mov S1, P0
cmp P2, P1
mov S2, P1
cmovge S2, P2
cmovl P1, P2
cmp S2, P0
cmovg P0, S2
cmovl S1, S2
cmp P3, P1
cmovg S2, P1
