# n=5 model=out iset=I1 prefix14_class=7739
mov S2, P1
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
mov S0, P2
cmp S0, P0
mov S1, P3
cmovg S0, P0
cmovg P0, P2
cmp S0, P3
cmovl S1, S0
cmovl S0, P3
cmp P0, S2
cmovl P2, P0
