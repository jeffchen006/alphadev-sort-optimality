# n=5 model=out iset=I1 prefix14_class=11932
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
mov S2, P3
cmovg S0, P0
cmp S2, P1
cmovle S2, P1
mov S1, S0
cmovl P1, P3
cmp S2, S0
cmovge S1, S2
cmovge S2, S0
cmp P2, P1
cmovle S1, P2
