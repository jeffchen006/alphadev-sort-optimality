# n=5 model=out iset=I1 prefix14_class=5371
mov S1, P2
mov S2, P3
cmp P0, P2
cmovl P2, P0
cmovg S1, P0
cmp P1, S2
cmovle P3, P1
cmovle P1, S2
mov P0, P2
cmp P3, P2
cmovl P0, P3
cmovg P2, P3
cmp S1, P1
cmovle S2, S1
