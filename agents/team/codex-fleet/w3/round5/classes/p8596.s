# n=5 model=out iset=I1 prefix14_class=8596
cmp P1, P2
cmovg S2, P2
cmovle S2, P1
cmovl P1, P2
mov S1, P3
cmp P3, P0
cmovg S1, P0
cmovg P0, P3
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
cmovle P1, P2
cmp S2, S1
cmovg P3, S2
