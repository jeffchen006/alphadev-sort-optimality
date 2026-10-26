# n=5 model=out iset=I1 prefix14_class=11211
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovle P3, S1
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovge P3, P1
cmp P0, P2
cmovle S0, P0
