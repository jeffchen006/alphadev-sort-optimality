# n=5 model=out iset=I1 prefix14_class=3964
mov S0, P1
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
mov S1, P2
mov S2, P0
cmp S1, P3
cmovle S1, P3
cmovl P3, P2
cmp P3, P0
cmovg S2, P3
cmovl P0, P3
cmp S1, S0
cmovle P0, S1
