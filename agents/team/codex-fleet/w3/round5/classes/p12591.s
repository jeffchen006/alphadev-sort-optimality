# n=5 model=out iset=I1 prefix14_class=12591
cmp P2, P0
mov S2, P2
cmovl P2, P0
cmovge S2, P0
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P1, S2
cmovg S0, S2
cmovle S0, P1
mov S0, P2
cmovl P1, S2
cmp S0, P3
