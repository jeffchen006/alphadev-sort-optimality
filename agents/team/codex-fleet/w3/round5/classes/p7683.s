# n=5 model=out iset=I1 prefix14_class=7683
cmp P1, P3
mov S1, P3
cmovl S1, P1
cmovg P3, P1
cmp P0, P2
mov S0, P3
cmovle P1, P0
cmovle P0, P2
cmovl P2, P1
mov S2, P2
cmp S2, S1
cmovl P2, S1
cmovle S1, S2
cmp P0, S0
