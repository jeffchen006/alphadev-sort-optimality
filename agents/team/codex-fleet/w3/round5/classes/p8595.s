# n=5 model=out iset=I1 prefix14_class=8595
cmp P3, P2
cmovg S2, P2
cmovle S2, P3
cmovl P3, P2
mov S1, P1
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmp P0, P3
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
cmp S2, S1
cmovg P1, S2
