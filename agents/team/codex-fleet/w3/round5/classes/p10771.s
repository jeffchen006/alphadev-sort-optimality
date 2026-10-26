# n=5 model=out iset=I1 prefix14_class=10771
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovg P2, P0
cmp P3, P1
cmovle P0, P3
cmovl P3, P1
cmovle P1, P0
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P1, S0
cmovge S2, S0
