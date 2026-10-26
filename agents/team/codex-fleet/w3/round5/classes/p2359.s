# n=5 model=out iset=I1 prefix14_class=2359
cmp P0, P3
mov S1, P0
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
mov S2, P1
cmovl S2, P2
cmovg P1, P2
cmp P0, S2
cmovge S0, P0
cmovle S0, S2
cmovl S2, P0
cmp P3, P1
cmovg S1, P3
