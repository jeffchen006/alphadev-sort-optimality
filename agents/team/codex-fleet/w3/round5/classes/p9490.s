# n=5 model=out iset=I1 prefix14_class=9490
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovg S0, P1
cmp P2, P3
cmovge S1, P2
cmovg P2, P3
mov S2, P2
cmovg P3, S1
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmp S0, P3
cmovle S1, S0
