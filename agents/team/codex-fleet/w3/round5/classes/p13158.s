# n=5 model=out iset=I1 prefix14_class=13158
mov S2, P1
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp S2, P3
mov S0, P2
cmovl P1, P3
cmovge S2, P3
cmp P0, S2
cmovge S1, P0
cmovg P0, S2
cmovg S2, S1
cmp P2, P1
