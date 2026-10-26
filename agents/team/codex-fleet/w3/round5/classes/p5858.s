# n=5 model=out iset=I1 prefix14_class=5858
mov S2, P3
cmp P3, P1
cmovle P3, P1
cmovge S2, P1
cmp P2, P0
mov S0, P3
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P2, S0
cmovge P3, P2
cmovl S0, P2
cmp P0, S2
cmovle S1, S2
