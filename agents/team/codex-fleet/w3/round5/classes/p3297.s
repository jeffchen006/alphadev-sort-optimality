# n=5 model=out iset=I1 prefix14_class=3297
mov S2, P0
mov S0, P1
cmp P3, P0
cmovl P0, P3
cmovge S2, P3
mov S1, P0
cmp S0, P2
cmovle S0, P2
cmovg P1, P2
cmp P0, P1
cmovg S1, P1
cmovl P0, P1
cmp S2, S0
cmovl P2, S2
