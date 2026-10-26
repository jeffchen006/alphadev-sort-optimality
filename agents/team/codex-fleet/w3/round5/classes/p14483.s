# n=5 model=out iset=I1 prefix14_class=14483
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovg S2, P1
cmovle S2, P2
mov S1, P3
cmovle P2, P1
cmp P3, S2
cmovle P3, S2
cmovl S2, S1
cmp P2, P0
cmovge P1, P2
