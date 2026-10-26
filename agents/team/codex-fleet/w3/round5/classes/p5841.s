# n=5 model=out iset=I1 prefix14_class=5841
mov S1, P3
cmp S1, P1
cmovg P3, P1
cmovle S1, P1
cmp P2, P0
cmovl P1, P2
cmovl P2, P0
cmovl P0, P1
mov S0, P0
mov S2, S1
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
cmp S2, P2
