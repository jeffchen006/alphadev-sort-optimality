# n=5 model=out iset=I1 prefix14_class=2328
mov S1, P3
mov S0, P0
cmp P0, P2
cmovle P0, P2
cmovg S0, P2
cmp S1, P1
cmovle P3, P1
cmovge S1, P1
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovl P3, P0
cmp S1, S0
cmovl P1, S0
