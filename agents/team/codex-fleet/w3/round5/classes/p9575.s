# n=5 model=out iset=I1 prefix14_class=9575
cmp P0, P1
cmovle S2, P0
cmovl P0, P1
cmovle P1, S2
cmp P3, P2
cmovle S1, P2
cmovg S1, P3
cmovge P3, P2
mov P2, P3
cmp P0, S1
mov S0, S1
cmovl S1, P0
cmovg S0, P0
cmp P2, P1
