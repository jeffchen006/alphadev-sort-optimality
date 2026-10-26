# n=5 model=out iset=I1 prefix14_class=2745
mov S2, P1
cmp P1, P2
cmovg P1, P2
cmovg P2, S2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
mov S2, P3
cmovl P0, S1
cmp S2, P2
cmovl P3, P2
cmovle P2, S2
mov S0, P2
cmp P0, P1
