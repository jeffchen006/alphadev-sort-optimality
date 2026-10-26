# n=5 model=out iset=I1 prefix14_class=9479
cmp P1, P3
mov S2, P2
cmovge S1, P1
cmovle S1, P3
cmovl P3, P1
cmp S2, P0
cmovg S2, P0
cmovg P0, P2
cmp S2, P3
cmovle P2, P3
cmovle P3, S2
cmovle S2, P2
cmp P0, S1
cmovle P3, P0
