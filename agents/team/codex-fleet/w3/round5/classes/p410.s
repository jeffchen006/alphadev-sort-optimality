# n=5 model=out iset=I1 prefix14_class=410
mov S1, P0
cmp P3, P0
cmovle P0, P3
mov S2, P1
cmovg S1, P3
cmp S2, P2
cmovge S2, P2
cmovg P2, P1
cmp P0, S2
mov P3, P0
cmovg P3, S2
cmovl P0, S2
cmp S1, P2
cmovle P3, S1
