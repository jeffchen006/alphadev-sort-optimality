# n=5 model=out iset=I1 prefix14_class=10981
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
cmovle S1, P3
