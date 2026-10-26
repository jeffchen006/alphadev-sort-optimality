# n=5 model=out iset=I1 prefix14_class=2349
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S1, P2
cmp P2, P0
cmovge P2, P0
cmovle S1, P0
cmp P1, S1
cmovg P0, S1
cmovge S1, P1
cmovle P0, P1
cmp P2, P3
cmovl S0, P3
