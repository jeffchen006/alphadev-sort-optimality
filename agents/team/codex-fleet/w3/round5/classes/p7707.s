# n=5 model=out iset=I1 prefix14_class=7707
cmp P1, P3
mov S2, P0
cmovle S0, P1
cmovg S0, P3
cmovle P1, P3
cmp P2, P0
cmovg S2, P2
cmovg P2, P0
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
cmovl S0, P0
cmp P1, S2
cmovle P2, S2
