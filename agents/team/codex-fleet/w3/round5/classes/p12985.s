# n=5 model=out iset=I1 prefix14_class=12985
mov S1, P3
cmp P0, P3
cmovl S1, P0
cmovle P0, P3
cmovle P3, S1
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
cmp P3, P2
cmovl S1, P2
cmovge P3, P2
cmp P1, P0
cmovg S0, P0
