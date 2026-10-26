# n=5 model=out iset=I1 prefix14_class=8402
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovl P0, P3
cmp P1, P2
cmovle S0, P2
cmovge S0, P1
cmovg P1, P2
cmp S1, S0
cmovl S2, S0
cmovge S2, S1
cmovg S1, S0
cmp P1, P0
cmovle P3, P0
