# n=5 model=out iset=I1 prefix14_class=195
mov S2, P3
cmp P3, P2
cmovl P3, P2
mov S0, P1
cmovl P2, S2
cmovle S2, P3
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmp P2, S0
cmovl P1, P2
cmovle P2, S0
cmovl S0, P1
cmp P3, P0
