# n=5 model=out iset=I1 prefix14_class=6632
cmp P1, P0
mov S2, P2
mov S1, P0
cmovge S1, P1
cmovg P1, P0
cmp P2, P3
cmovge S2, P3
cmovle P2, P3
mov P0, P2
cmp S1, P2
cmovg P2, S1
cmovg S1, P0
cmp S2, P1
cmovl P3, S2
