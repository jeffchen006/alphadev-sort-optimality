# n=5 model=out iset=I1 prefix14_class=7012
cmp P3, P0
mov S2, P1
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P2
cmovle P1, P2
cmovle P2, S2
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
mov P2, P1
mov P0, S0
