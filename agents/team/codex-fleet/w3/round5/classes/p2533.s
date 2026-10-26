# n=5 model=out iset=I1 prefix14_class=2533
mov S2, P3
mov S1, P1
cmp P2, P3
cmovl P3, P2
cmovl P2, S2
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
cmp S1, P2
cmovge S0, S1
cmovge S1, P2
cmovle S0, P2
cmp P0, P3
cmovg S0, P0
