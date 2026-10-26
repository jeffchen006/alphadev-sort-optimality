# n=5 model=out iset=I1 prefix14_class=6374
mov S2, P0
cmp P3, P0
mov S0, P2
cmovg P0, P3
cmovle S2, P3
cmp P1, S0
cmovle P2, P1
cmovg S0, P1
mov S1, P0
cmp S0, S1
cmovle P0, S0
cmovg S1, S0
cmp P2, S2
cmovl P1, S2
