# n=5 model=out iset=I1 prefix14_class=3975
mov S1, P1
cmp S1, P3
cmovl P1, P3
mov S0, P0
cmovg S1, P3
cmp P2, P0
cmovg S0, P2
cmovl P0, P2
mov S2, S1
cmp P0, S1
cmovg S2, P0
cmovg P0, S1
cmp P1, S0
cmovle P0, S0
