# n=5 model=out iset=I1 prefix14_class=8897
cmp P2, P3
mov S1, P2
cmovl S1, P3
mov S0, P0
cmovg P2, P3
cmp P1, P0
cmovl S0, P1
cmovle P1, P0
cmp P1, S1
mov P0, S0
cmovle S2, P1
cmovl P1, S1
cmovl S1, S2
cmp S0, P2
