# n=5 model=out iset=I1 prefix14_class=14391
cmp P0, P3
cmovle S2, P3
cmovl P3, P0
cmovge S2, P0
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovg S1, P1
cmp S1, P3
cmovg P1, S1
cmovge S1, P3
cmovg P3, P1
cmp P2, S2
cmovg S0, P2
