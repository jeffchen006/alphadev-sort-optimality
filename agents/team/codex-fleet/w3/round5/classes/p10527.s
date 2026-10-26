# n=5 model=out iset=I1 prefix14_class=10527
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
mov S0, P0
cmovl P2, S1
cmp P3, S0
cmovg S0, P3
mov S1, P2
cmovg P3, P0
cmp S0, P1
cmovle P0, P1
cmovle P1, S0
mov S2, P1
cmovl S0, P0
