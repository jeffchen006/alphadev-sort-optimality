# n=5 model=out iset=I1 prefix14_class=3552
cmp P2, P0
cmovle S2, P2
mov S0, P3
cmovl P2, P0
cmovle P0, S2
cmp S0, P1
cmovl S0, P1
mov S1, P0
cmovle P1, P3
cmp P1, P0
cmovg P0, P1
cmovle S1, P1
cmp S0, P2
mov P1, P0
