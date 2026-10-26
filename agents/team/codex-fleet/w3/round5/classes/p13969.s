# n=5 model=out iset=I1 prefix14_class=13969
cmp P3, P0
mov S0, P1
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P2, S0
cmovle P1, P2
cmovg S0, P2
cmp S0, P3
cmovl S2, P3
cmovl P3, S0
cmovl S0, S2
cmp S1, P1
mov P2, P3
