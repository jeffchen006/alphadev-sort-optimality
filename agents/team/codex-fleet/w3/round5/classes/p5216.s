# n=5 model=out iset=I1 prefix14_class=5216
mov S1, P0
cmp P0, P1
cmovg S1, P1
cmovl P0, P1
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovge S0, P3
cmp S0, S1
cmovge S2, S0
cmovge S0, S1
cmovg S1, S2
cmp P0, P2
mov S0, P2
