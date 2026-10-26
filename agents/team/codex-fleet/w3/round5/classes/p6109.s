# n=5 model=out iset=I1 prefix14_class=6109
cmp P3, P1
cmovl S2, P1
cmovge S2, P3
cmovle P1, P3
mov S1, P2
cmp P0, S1
cmovge S1, P0
cmovg P0, P2
mov P2, S1
cmp S1, S2
cmovg S1, S2
cmovge S2, P2
cmp P1, P0
cmovl P3, P0
