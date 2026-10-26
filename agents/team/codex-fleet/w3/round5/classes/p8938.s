# n=5 model=out iset=I1 prefix14_class=8938
cmp P2, P3
cmovg S2, P2
cmovle S2, P3
cmovge P2, P3
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P0, S2
cmovg S1, P0
cmovge P0, S2
cmovle S1, S2
cmp P2, P1
cmovle S0, P1
