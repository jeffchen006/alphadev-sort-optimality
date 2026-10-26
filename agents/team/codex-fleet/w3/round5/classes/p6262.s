# n=5 model=out iset=I1 prefix14_class=6262
mov S2, P0
cmp P1, P0
mov S0, P2
cmovl P0, P1
cmovle P1, S2
cmp P3, P2
mov S1, P1
cmovg S0, P3
cmovl P2, P3
cmp S0, S1
cmovl P1, S0
cmovle S0, S1
cmp P2, P0
cmovge S1, P2
