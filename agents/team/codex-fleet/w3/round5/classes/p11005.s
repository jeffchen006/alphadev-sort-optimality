# n=5 model=out iset=I1 prefix14_class=11005
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P3, P2
cmovg S2, P3
cmovge P3, P2
cmovle S2, P2
cmovg P2, S2
cmp P2, P0
cmovle P2, P0
cmovl P0, S2
cmp P1, P3
cmovle S2, P3
