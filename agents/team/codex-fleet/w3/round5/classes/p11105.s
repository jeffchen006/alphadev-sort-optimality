# n=5 model=out iset=I1 prefix14_class=11105
cmp P1, P0
mov S0, P0
cmovge P0, P1
cmovl S0, P1
cmp P3, P2
cmovle P1, P3
cmovl P3, P2
cmovle P2, P1
cmp P0, P3
mov S2, P3
cmovl P3, P0
cmovle P0, S2
cmp P2, S0
mov S1, P2
