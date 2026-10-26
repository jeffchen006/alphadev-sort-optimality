# n=5 model=out iset=I1 prefix14_class=5173
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovle P1, S2
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P2, P1
mov S0, P3
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, S0
