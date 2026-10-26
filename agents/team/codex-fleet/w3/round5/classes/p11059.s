# n=5 model=out iset=I1 prefix14_class=11059
mov S2, P2
cmp S2, P3
cmovg S2, P3
cmovg P3, P2
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
mov S1, P0
cmovl P1, P2
mov S0, P1
cmp P3, S0
cmovle P1, P3
cmovle P3, S0
cmp S2, S1
