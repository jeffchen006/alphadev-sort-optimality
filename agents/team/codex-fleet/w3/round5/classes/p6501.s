# n=5 model=out iset=I1 prefix14_class=6501
mov S2, P2
cmp S2, P1
cmovl P2, P1
mov S1, P0
cmovl P1, S2
cmp P3, S1
cmovle S1, P3
cmovg P0, P3
cmp P0, P2
cmovle S2, P2
mov S0, S1
cmovle P2, P0
cmovl P0, S2
cmp S0, P1
