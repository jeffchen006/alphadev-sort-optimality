# n=5 model=out iset=I1 prefix14_class=5033
mov S0, P2
cmp P0, P2
cmovle S0, P0
mov S1, P1
cmovg P2, P0
cmp S1, P3
mov S2, P2
cmovg P1, P3
cmovl S1, P3
cmovle P3, P1
cmp S0, P1
cmovl P1, S0
cmovg P3, S0
mov P1, P3
