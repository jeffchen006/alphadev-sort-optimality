# n=5 model=out iset=I1 prefix14_class=4873
cmp P0, P1
cmovge S1, P1
cmovl S1, P0
cmovg P1, P0
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovge S2, P2
mov P2, S1
cmp S1, P3
cmovle P2, P3
cmovg S1, P3
cmp S2, P1
cmovle P3, P1
