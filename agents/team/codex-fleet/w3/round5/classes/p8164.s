# n=5 model=out iset=I1 prefix14_class=8164
cmp P3, P1
mov S2, P3
cmovle S2, P1
mov S0, P0
cmovle P1, P3
cmp P0, P2
cmovg P0, P2
cmovg P2, S0
cmp P1, P0
cmovle S1, P1
cmovge S1, P0
cmovl P1, P0
cmp S2, P2
cmovle S1, S2
