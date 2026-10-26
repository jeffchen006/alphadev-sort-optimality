# n=5 model=out iset=I1 prefix14_class=2826
cmp P0, P1
cmovge S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P2, P3
cmovg S2, P3
cmovle S2, P2
cmovge P3, P2
mov S1, P0
cmp P0, P3
cmovl P0, P3
cmovle P3, S1
cmp S0, S2
cmovge P0, S0
