# n=5 model=out iset=I1 prefix14_class=6004
mov S2, P2
mov S1, P3
cmp S1, P0
cmovg P3, P0
cmovle S1, P0
cmp P1, S2
cmovl P2, P1
cmovg S2, P1
cmovle P1, S2
cmp S1, S2
cmovg S2, S1
cmovg S1, P1
mov S0, S1
mov S2, P2
