# n=5 model=out iset=I1 prefix14_class=479
cmp P2, P3
cmovg S2, P2
cmovle S2, P3
mov S1, P1
cmovle P3, P2
cmp S1, P0
cmovg P1, P0
cmovg P0, S1
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
mov P2, P3
cmp P0, S2
