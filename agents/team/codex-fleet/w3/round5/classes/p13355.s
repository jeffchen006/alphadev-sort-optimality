# n=5 model=out iset=I1 prefix14_class=13355
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
mov S2, P2
cmp P3, P2
cmovl P2, P3
mov S1, P1
cmovge S2, P3
cmp P2, P1
cmovle P1, P2
cmovg S1, P2
cmp S2, P0
cmovge S0, P0
