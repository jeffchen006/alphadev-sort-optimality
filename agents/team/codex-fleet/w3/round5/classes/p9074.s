# n=5 model=out iset=I1 prefix14_class=9074
mov S0, P1
cmp P2, S0
cmovl S0, P2
cmovg P1, P2
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovl P0, P3
cmp S2, P1
cmovle P3, S2
cmovle S2, P1
cmovle P1, P3
cmp P0, S0
cmovle P2, S0
