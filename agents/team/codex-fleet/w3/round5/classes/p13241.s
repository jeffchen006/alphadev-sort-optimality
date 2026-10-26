# n=5 model=out iset=I1 prefix14_class=13241
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovle P2, S0
mov S0, P3
cmp P3, P0
cmovg S0, P0
cmovle P3, P0
cmp S0, P1
cmovl S1, P1
cmovl P1, S0
mov P0, P2
cmovl S0, S1
cmp P0, P3
