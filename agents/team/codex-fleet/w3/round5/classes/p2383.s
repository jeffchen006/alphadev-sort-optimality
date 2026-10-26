# n=5 model=out iset=I1 prefix14_class=2383
mov S2, P2
cmp P2, P1
cmovg S2, P1
mov S0, P3
cmovg P1, P2
cmp P0, S0
cmovg P3, P0
cmovle S0, P0
mov P0, P1
cmp P1, P3
cmovl P1, P3
cmovle P3, P0
mov P1, S2
cmp S2, S0
