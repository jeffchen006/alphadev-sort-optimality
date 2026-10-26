# n=5 model=out iset=I1 prefix14_class=8730
cmp P2, P0
cmovle S1, P0
cmovge S1, P2
cmovg P2, P0
cmp P1, P3
cmovle P0, P1
cmovl P1, P3
cmovle P3, P0
mov S2, P1
cmp S1, S2
cmovle P1, S1
mov S0, P2
cmovge S2, S1
cmp P2, P3
