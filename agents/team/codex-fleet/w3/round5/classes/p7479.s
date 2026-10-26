# n=5 model=out iset=I1 prefix14_class=7479
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovle P1, P2
cmp P3, P0
cmovg P2, P0
cmovle P2, P3
cmovl P3, P0
cmp P2, S1
cmovle S0, P2
cmovle P2, S1
cmovl S1, S0
cmp P1, P3
cmovge P0, P3
