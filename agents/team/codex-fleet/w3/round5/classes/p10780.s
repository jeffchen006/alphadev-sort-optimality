# n=5 model=out iset=I1 prefix14_class=10780
mov S0, P2
cmp P0, S0
cmovg S0, P0
cmovle P2, P0
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
cmp S0, P1
cmovle S1, S0
cmovle S0, P1
cmovl P1, S1
cmp P2, P3
cmovle S2, P3
