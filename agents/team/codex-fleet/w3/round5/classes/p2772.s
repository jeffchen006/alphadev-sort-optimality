# n=5 model=out iset=I1 prefix14_class=2772
cmp P0, P3
cmovge S2, P0
cmovle S2, P3
cmovge P0, P3
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovl P2, P1
cmovg P1, P2
cmp S2, P2
cmovle P1, S2
cmovl S2, P2
cmp P0, S1
cmovle S0, P0
