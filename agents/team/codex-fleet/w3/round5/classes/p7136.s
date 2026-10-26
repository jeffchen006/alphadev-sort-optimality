# n=5 model=out iset=I1 prefix14_class=7136
mov S0, P2
mov S2, P0
cmp P1, S2
cmovl P0, P1
cmovle P1, S2
cmp S0, P3
cmovl P2, P3
cmovg S0, P3
mov S1, P0
cmp P0, S0
cmovle S1, S0
cmovg P0, S0
cmp P2, P1
cmovle P3, P1
