# n=5 model=out iset=I1 prefix14_class=13841
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovle P0, P2
mov S1, P1
cmp P3, S1
cmovle P1, P3
cmovg S1, P3
cmp P0, S1
mov S0, S1
cmovle P3, P1
cmovle S1, P0
cmovl P0, S0
cmp S2, P1
