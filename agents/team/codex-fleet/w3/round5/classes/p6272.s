# n=5 model=out iset=I1 prefix14_class=6272
mov S1, P1
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
mov S0, P2
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmp P0, P3
cmovge S2, P3
cmovl S2, P0
cmovl P0, P3
cmp S1, S0
cmovle P0, S1
