# n=5 model=out iset=I1 prefix14_class=6804
mov S2, P3
mov S0, P1
cmp S2, P0
cmovl P3, P0
cmovle P0, S2
cmp S0, P2
cmovg P1, P2
cmovle S0, P2
mov S1, S0
cmp P3, S1
cmovge S0, P3
cmovle S1, P3
cmp P1, P0
cmovle P2, P1
