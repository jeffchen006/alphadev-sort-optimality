# n=5 model=out iset=I1 prefix14_class=2889
cmp P2, P0
mov S0, P1
cmovle S2, P2
cmovl P2, P0
cmovl P0, S2
mov S1, P2
cmp S0, P3
cmovg P1, P3
cmovle S0, P3
cmp S0, P2
cmovle P2, S0
cmovl S0, S1
cmp P1, P0
mov P3, P1
