# n=5 model=out iset=I1 prefix14_class=3492
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovl P3, P1
cmp P0, P2
mov S2, P0
cmovge S2, P2
cmovl P0, P2
mov S0, S2
cmp S1, S2
cmovg S0, S1
cmovg S1, S2
cmp P0, P3
cmovl P2, P0
