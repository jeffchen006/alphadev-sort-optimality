# n=5 model=out iset=I1 prefix14_class=12572
mov S2, P1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P2, S2
cmovl S2, P2
mov S1, S2
cmovl P2, P1
cmp S2, P0
cmovg S1, P0
cmovle S2, P0
cmp P2, P3
cmovle P1, P2
