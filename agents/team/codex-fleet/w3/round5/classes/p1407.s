# n=5 model=out iset=I1 prefix14_class=1407
cmp P2, P0
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp P1, P3
mov S2, P3
cmovge S2, P1
cmovle P3, P1
cmp P2, S2
cmovge P1, S2
cmovle P1, P2
mov S0, P3
cmovl P2, S2
cmovl S2, P1
