# n=5 model=out iset=I1 prefix14_class=3122
cmp P0, P3
cmovle S2, P0
cmovg S2, P3
cmovg P3, P0
mov S1, P1
cmp P2, P1
cmovg S1, P2
cmovle P1, P2
cmp S2, P1
cmovle P0, S2
cmovg P0, P1
cmovl S2, P1
mov P0, P3
cmp S1, P0
