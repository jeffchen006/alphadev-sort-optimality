# n=5 model=out iset=I1 prefix14_class=2360
cmp P1, P0
cmovg S1, P0
cmovle S1, P1
mov S0, P2
cmovl P1, P0
cmovle P0, S1
cmp S0, P3
cmovle S0, P3
cmovg P2, P3
cmp S0, P1
cmovge S2, S0
cmovle S2, P1
cmovle P1, S0
mov S2, P1
