# n=5 model=out iset=I1 prefix14_class=12442
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmovge S2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovg S1, P1
cmp P2, S1
cmovle S0, S1
cmovl S1, P2
cmovle P2, S0
cmp P0, S2
cmovge P1, P0
