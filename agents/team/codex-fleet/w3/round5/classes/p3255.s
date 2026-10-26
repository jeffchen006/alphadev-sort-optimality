# n=5 model=out iset=I1 prefix14_class=3255
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovg S0, P1
mov S2, P2
cmp P3, S2
mov S1, P0
cmovg S2, P3
cmovg P3, P2
cmp S1, P3
cmovg S1, P3
cmovl P0, P3
mov S1, S0
cmp S2, S1
