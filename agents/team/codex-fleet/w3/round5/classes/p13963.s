# n=5 model=out iset=I1 prefix14_class=13963
mov S1, P0
mov S0, P2
cmp P0, P3
cmovg S1, P3
cmovl P0, P3
cmp P1, S0
cmovle S0, P1
cmovg P2, P1
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
cmovl P2, S2
cmp S0, S1
cmovle P1, S0
