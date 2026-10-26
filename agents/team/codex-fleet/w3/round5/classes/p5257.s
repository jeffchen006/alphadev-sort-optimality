# n=5 model=out iset=I1 prefix14_class=5257
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovg P3, P0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
mov S2, P1
cmovle P2, S0
cmp P3, S2
cmovg P1, P3
cmovle S2, P3
cmp P2, S1
cmovg P0, S1
