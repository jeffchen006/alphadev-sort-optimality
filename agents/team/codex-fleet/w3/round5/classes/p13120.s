# n=5 model=out iset=I1 prefix14_class=13120
mov S2, P2
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovle P0, P3
cmp S2, P1
cmovl P2, P1
cmovl P1, S2
cmp P1, S0
cmovle P3, S0
cmovle S0, P1
mov S0, P2
cmovle P1, P3
cmp S0, P0
