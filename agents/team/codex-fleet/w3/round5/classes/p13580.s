# n=5 model=out iset=I1 prefix14_class=13580
cmp P1, P2
cmovge S0, P1
cmovg P1, P2
cmovle S0, P2
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
mov S2, S0
cmovle P3, P0
cmp P1, P3
cmovl P0, P1
cmovle P1, P3
cmovl P3, P0
cmp S2, S1
