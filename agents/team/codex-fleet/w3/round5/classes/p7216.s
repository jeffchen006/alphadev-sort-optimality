# n=5 model=out iset=I1 prefix14_class=7216
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
cmovle S1, P2
mov S2, P0
cmp P1, S2
cmovg S2, P1
mov S0, P3
cmovle P0, P1
cmp S0, P0
cmovle P3, P0
cmovg S0, P0
cmp S2, S1
cmovl P1, S2
