# n=5 model=out iset=I1 prefix14_class=4903
mov S0, P3
cmp S0, P0
cmovl S0, P0
cmovle P0, P3
mov S1, P2
cmp P1, S1
cmovle P2, P1
cmovle P1, S1
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmovle S2, P2
cmp S0, P1
cmovl P0, S0
