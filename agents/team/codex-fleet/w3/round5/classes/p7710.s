# n=5 model=out iset=I1 prefix14_class=7710
cmp P0, P3
mov S1, P1
cmovle S2, P0
cmovg S2, P3
cmovle P0, P3
cmp P2, S1
cmovge S1, P2
cmovg P2, P1
cmp S2, P2
mov P1, S1
cmovl P3, P2
cmovl P2, S2
cmovl S2, P3
cmp S1, P0
