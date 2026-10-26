# n=5 model=out iset=I1 prefix14_class=3664
cmp P3, P0
cmovg S2, P3
cmovle S2, P0
cmovle P0, P3
cmp P1, P2
cmovl S1, P1
mov P3, S2
cmovle P1, P2
cmovl P2, S1
mov S0, P2
cmp S0, P0
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
