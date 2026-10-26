# n=5 model=out iset=I1 prefix14_class=11591
mov S1, P0
cmp S1, P3
cmovl P0, P3
cmovg S1, P3
cmp P1, P2
mov S0, P1
cmovle P1, P2
cmovg S0, P2
cmp S0, S1
cmovle P2, S1
cmovl S1, S0
cmovle S0, P2
mov S1, P0
cmp P0, P1
