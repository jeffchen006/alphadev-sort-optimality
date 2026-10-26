# n=5 model=out iset=I1 prefix14_class=13403
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovg S1, P0
mov P0, P3
cmp P1, P3
cmovle P3, P1
cmovl P1, P0
cmp S1, P2
mov P3, S1
