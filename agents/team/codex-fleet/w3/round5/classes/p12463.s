# n=5 model=out iset=I1 prefix14_class=12463
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
cmp P3, P2
mov S2, P3
cmovl P3, P2
cmovg S2, P2
cmovg P2, P3
cmp S2, P1
cmovg S1, P1
cmovg P1, S2
cmovg S2, S1
cmp P3, P0
