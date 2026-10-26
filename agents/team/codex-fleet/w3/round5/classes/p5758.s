# n=5 model=out iset=I1 prefix14_class=5758
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovge S1, P3
cmovle P3, S1
cmp P2, P0
cmovle S0, P0
cmovge S0, P2
cmovle P0, P2
cmp P0, S1
cmovg S1, P0
cmovl P3, P0
cmp P1, S0
cmovge P0, S1
