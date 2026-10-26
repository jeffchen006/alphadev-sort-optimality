# n=5 model=out iset=I1 prefix14_class=2528
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovle P2, P3
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
mov S2, P2
cmp P2, S1
cmovl S2, S1
cmovg P2, S1
mov S2, P1
cmp P1, S0
