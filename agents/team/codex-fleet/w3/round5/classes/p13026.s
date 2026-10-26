# n=5 model=out iset=I1 prefix14_class=13026
cmp P0, P3
cmovg S0, P0
cmovle S0, P3
cmovg P0, P3
cmp P2, P1
cmovl S1, P2
cmovge S1, P1
cmovge P1, P2
cmp S1, P0
cmovl S2, S1
cmovle S1, P0
cmovl P0, S2
cmp S0, P1
cmovle S2, S0
