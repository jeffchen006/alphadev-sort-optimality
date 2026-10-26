# n=5 model=out iset=I1 prefix14_class=2430
mov S2, P0
mov S1, P2
cmp P3, S2
cmovg S2, P3
cmovle P0, P3
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
mov P3, S2
cmp S1, S2
cmovg P3, S1
mov P3, P0
cmovg S1, S2
cmp P1, P3
