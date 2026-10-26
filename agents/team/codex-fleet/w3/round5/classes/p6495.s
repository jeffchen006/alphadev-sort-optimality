# n=5 model=out iset=I1 prefix14_class=6495
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
cmovge S2, P3
cmp S2, S1
cmovl P3, S1
cmovl S1, S2
cmovl S2, P3
cmp P0, P1
mov S2, P1
