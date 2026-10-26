# n=5 model=out iset=I1 prefix14_class=9521
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
mov S0, P3
cmovle P0, P2
mov S1, P0
cmp S0, P1
cmovg S0, P1
cmovl P3, P1
cmp P0, S0
cmovle S1, S0
cmovl S0, P0
cmp S2, P3
mov S0, S1
