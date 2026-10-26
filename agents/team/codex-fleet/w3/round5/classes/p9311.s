# n=5 model=out iset=I1 prefix14_class=9311
cmp P0, P2
mov S2, P0
cmovle S2, P2
cmovl P2, P0
mov S1, P2
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P1, S1
cmovge P2, P1
cmovl S1, P1
cmp P3, S2
cmovle S0, S2
