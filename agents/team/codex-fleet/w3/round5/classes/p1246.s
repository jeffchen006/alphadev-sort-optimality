# n=5 model=out iset=I1 prefix14_class=1246
mov S1, P2
cmp P0, P2
cmovg S1, P0
cmovle P2, P0
cmp P1, P3
mov S2, P3
cmovg S2, P1
cmovl P3, P1
cmp S1, S2
cmovle P1, S2
cmovg P1, S1
cmovle S2, S1
mov P1, S2
cmp P2, P3
