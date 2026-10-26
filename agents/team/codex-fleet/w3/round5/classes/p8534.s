# n=5 model=out iset=I1 prefix14_class=8534
cmp P0, P3
cmovge S1, P0
cmovl S1, P3
cmovl P3, P0
cmp P2, P1
cmovg S2, P2
cmovle S2, P1
cmovle P1, P2
cmp S1, S2
cmovge S0, S2
cmovg S2, S1
mov P0, P1
cmovge S1, S0
cmp P3, P1
