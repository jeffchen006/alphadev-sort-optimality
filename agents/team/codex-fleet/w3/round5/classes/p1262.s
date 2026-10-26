# n=5 model=out iset=I1 prefix14_class=1262
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmovle S2, P3
mov P3, P2
mov S1, S2
cmp P2, P1
cmovle P3, P1
cmovl P1, P2
cmp S1, P3
cmovle S2, P3
mov S2, P0
cmovge S1, P3
cmp P0, P1
