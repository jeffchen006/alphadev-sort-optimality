# n=5 model=out iset=I1 prefix14_class=5611
mov S0, P0
cmp P0, P3
cmovge S0, P3
cmovl P0, P3
cmp P2, P1
mov S2, S0
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
cmp S0, P1
cmovg S2, P1
cmovg P1, S0
cmp P2, P0
mov S0, P2
