# n=5 model=out iset=I1 prefix14_class=13248
cmp P0, P1
mov S1, P1
cmovle P1, P0
mov S0, P3
cmovl P0, S1
cmp S0, P2
cmovle S0, P2
cmovg P3, P2
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
mov S2, S0
cmovl P1, S1
cmp S2, P0
