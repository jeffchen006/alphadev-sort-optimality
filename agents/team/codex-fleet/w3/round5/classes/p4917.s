# n=5 model=out iset=I1 prefix14_class=4917
mov S2, P0
cmp P2, S2
cmovle P0, P2
cmovl P2, S2
mov S2, P3
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovle P0, P1
cmp S2, P2
mov S0, P0
