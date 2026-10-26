# n=5 model=out iset=I1 prefix14_class=11437
cmp P1, P0
cmovle S2, P0
cmovge S2, P1
cmovle P0, P1
cmp P3, P2
cmovge S1, P2
cmovl S1, P3
cmovl P3, P2
cmp P0, S1
cmovg S0, P0
cmovg P0, S1
mov P0, S2
cmovg S1, S0
cmp P0, P3
