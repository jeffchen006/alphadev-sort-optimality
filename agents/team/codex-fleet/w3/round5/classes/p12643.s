# n=5 model=out iset=I1 prefix14_class=12643
mov S2, P0
cmp P2, S2
mov S1, P1
cmovg P0, P2
cmovle S2, P2
cmp P3, P1
cmovle P1, P3
cmovl P3, S1
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmovle S2, S0
cmp P3, P0
cmovle S0, P3
