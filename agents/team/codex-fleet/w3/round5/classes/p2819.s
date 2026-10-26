# n=5 model=out iset=I1 prefix14_class=2819
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmovle P0, S0
cmp P2, P3
mov S1, P2
cmovg S1, P3
cmovg P3, P2
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
mov P2, S1
cmovl P3, S2
cmp S1, P1
