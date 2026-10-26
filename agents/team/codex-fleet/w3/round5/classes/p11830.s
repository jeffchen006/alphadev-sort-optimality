# n=5 model=out iset=I1 prefix14_class=11830
cmp P0, P2
cmovg S2, P0
cmovle S2, P2
cmovl P2, P0
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovle P1, S1
cmp P3, S2
cmovge S0, S2
cmovl S0, P3
cmovg S2, P3
cmovge P3, S0
cmp P1, P2
