# n=5 model=out iset=I1 prefix14_class=14199
cmp P2, P1
mov S0, P3
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
mov S2, P2
cmp S2, P3
cmovl S2, P3
cmovle P3, P2
cmovg P2, P3
mov S0, P0
