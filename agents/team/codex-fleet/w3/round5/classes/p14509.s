# n=5 model=out iset=I1 prefix14_class=14509
cmp P1, P0
cmovg S0, P0
cmovge P0, P1
cmovg P1, S0
cmovle S0, P1
cmp P3, P2
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp P1, P2
cmovl P1, P2
cmovl P2, S0
cmp P0, P3
cmovge S2, P3
