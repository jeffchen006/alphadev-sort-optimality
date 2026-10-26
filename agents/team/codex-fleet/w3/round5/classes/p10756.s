# n=5 model=out iset=I1 prefix14_class=10756
mov S0, P1
cmp P2, P1
cmovle S0, P2
cmovge P1, P2
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
mov S1, P3
cmp P3, P1
cmovle P3, P1
cmovle P1, S1
cmp P0, S0
cmovg S2, S0
