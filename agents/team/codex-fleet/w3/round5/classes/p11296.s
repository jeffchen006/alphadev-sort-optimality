# n=5 model=out iset=I1 prefix14_class=11296
mov S2, P1
cmp P3, P0
cmovge S1, P3
cmovl S1, P0
cmovle P0, P3
cmp S2, P2
cmovle S2, P2
cmovl P2, P1
cmp S1, S2
cmovg P3, S1
cmovge S1, S2
cmovg S2, P3
mov S2, P0
cmp S2, P2
