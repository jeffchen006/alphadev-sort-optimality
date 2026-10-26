# n=5 model=out iset=I1 prefix14_class=9927
mov S2, P0
cmp P0, P2
cmovg S2, P2
cmovg P2, P0
cmovl P0, P2
mov S0, P3
cmp S0, P1
cmovle S0, P1
cmovl P1, P3
cmp P0, S0
cmovg P0, S0
cmovle P2, S0
cmp P1, S2
cmovle P2, S2
