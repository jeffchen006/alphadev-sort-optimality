# n=5 model=out iset=I1 prefix14_class=12211
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
cmp P3, P2
cmovg S1, P2
cmovle S1, P3
cmovl P3, P2
cmp S1, P0
cmovle S0, S1
cmovge S0, P0
cmovg P0, S1
mov S0, P0
cmp P3, P1
