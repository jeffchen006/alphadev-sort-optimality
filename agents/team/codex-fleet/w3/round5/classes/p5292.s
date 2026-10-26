# n=5 model=out iset=I1 prefix14_class=5292
mov S1, P0
mov S2, P3
cmp S1, P2
cmovg P0, P2
cmovl S1, P2
cmp P3, P1
cmovg S2, P1
mov S0, P0
cmovl P3, P1
cmp P0, S2
cmovle S0, S2
cmovg P0, S2
cmp P3, S1
cmovle P0, S1
