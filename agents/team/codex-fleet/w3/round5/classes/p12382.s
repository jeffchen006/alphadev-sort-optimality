# n=5 model=out iset=I1 prefix14_class=12382
mov S0, P2
cmp S0, P0
cmovg S0, P0
mov S2, S0
cmovl P2, P0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp P3, S0
cmovge S0, P3
cmovle S2, P3
cmp P2, P1
cmovl P0, P1
