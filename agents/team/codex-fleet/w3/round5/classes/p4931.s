# n=5 model=out iset=I1 prefix14_class=4931
mov S0, P3
cmp S0, P0
mov S1, P1
cmovl P3, P0
cmovg S0, P0
cmp S1, P2
cmovl P1, P2
cmovle P2, S1
cmp S0, P2
cmovg S1, S0
mov S2, P3
cmovg S0, P2
cmovg P2, S1
cmp S2, P1
