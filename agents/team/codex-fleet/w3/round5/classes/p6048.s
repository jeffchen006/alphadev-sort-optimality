# n=5 model=out iset=I1 prefix14_class=6048
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovle P1, P0
cmp P2, P3
mov S2, S0
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, S0
cmovle S2, P2
cmovg S0, P2
mov S0, P3
cmp S0, P1
