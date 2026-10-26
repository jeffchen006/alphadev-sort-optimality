# n=5 model=out iset=I1 prefix14_class=2524
mov S0, P1
cmp P3, S0
cmovg P1, P3
cmovle S0, P3
mov S2, P2
cmovle P3, P1
cmp P2, P0
cmovle P2, P0
cmovl P0, S2
cmp P3, P2
cmovg P3, P2
cmovg P2, P1
cmovg P1, P3
cmp S0, P0
