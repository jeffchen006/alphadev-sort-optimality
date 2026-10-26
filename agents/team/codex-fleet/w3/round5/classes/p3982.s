# n=5 model=out iset=I1 prefix14_class=3982
cmp P1, P2
cmovle S1, P1
cmovg S1, P2
cmovl P1, P2
mov S0, P0
cmp P3, P0
cmovg P0, P3
cmovle S0, P3
mov S2, S1
cmp S0, S2
cmovg S1, S0
cmovge S0, S2
cmp P0, P1
mov S0, P0
