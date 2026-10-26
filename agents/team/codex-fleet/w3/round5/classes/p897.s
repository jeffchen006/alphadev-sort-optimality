# n=5 model=out iset=I1 prefix14_class=897
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
cmovge S0, P0
cmp P1, P3
cmovle S2, P1
cmovg S2, P3
cmovg P3, P1
cmp P3, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, S2
cmovle S1, P2
