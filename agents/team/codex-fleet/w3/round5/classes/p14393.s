# n=5 model=out iset=I1 prefix14_class=14393
mov S1, P1
cmp P0, P3
cmovle S2, P3
cmovl P3, P0
cmovge S2, P0
cmp P1, P2
cmovle P1, P2
cmovg S1, P2
cmp S1, P3
cmovg P2, S1
cmovge S1, P3
cmovg P3, P2
cmp S2, P1
cmovle S0, P1
