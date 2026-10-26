# n=5 model=out iset=I1 prefix14_class=2364
mov S0, P2
mov S1, P0
cmp S1, P3
cmovle S1, P3
cmovg P0, P3
cmp P1, S0
cmovg S0, P1
cmovl P2, P1
cmovle P1, S0
cmp S1, S0
cmovl P1, S1
cmovge S0, S1
cmp P0, P2
cmovg S0, P0
