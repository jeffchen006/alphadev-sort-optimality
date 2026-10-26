# n=5 model=out iset=I1 prefix14_class=11703
cmp P1, P0
cmovl S1, P1
cmovl P1, P0
mov S0, P3
cmovl P0, S1
cmp P2, P3
cmovge S0, P2
cmovl P3, P2
cmp P1, S0
cmovge P2, S0
cmovle P2, P1
cmovle P1, S0
cmp P0, P3
cmovle S2, P3
