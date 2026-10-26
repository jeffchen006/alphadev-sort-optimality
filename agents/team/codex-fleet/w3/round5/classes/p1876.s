# n=5 model=out iset=I1 prefix14_class=1876
mov S2, P0
cmp P2, P0
cmovl P0, P2
cmovl P2, S2
mov S1, P1
cmp P3, S1
mov S0, P2
cmovle S1, P3
cmovge P1, P3
cmp P1, P2
cmovl S0, P1
cmovle P1, P2
cmp P0, S1
cmovl P3, P0
