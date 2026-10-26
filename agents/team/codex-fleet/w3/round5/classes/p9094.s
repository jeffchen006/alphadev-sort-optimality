# n=5 model=out iset=I1 prefix14_class=9094
cmp P2, P1
mov S2, P2
cmovle P2, P1
mov S0, P0
cmovl P1, S2
cmp P0, P3
cmovl S0, P3
cmovge P0, P3
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P2, S0
cmovge S2, P2
