# n=5 model=out iset=I1 prefix14_class=3653
mov S0, P0
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp P1, S0
cmovle S0, P1
mov S2, P3
cmovl P1, P0
cmp S0, P3
cmovl S2, S0
mov P0, P2
cmovg P3, S0
cmp P1, P2
