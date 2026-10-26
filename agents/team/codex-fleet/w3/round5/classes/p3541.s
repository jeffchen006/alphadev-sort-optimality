# n=5 model=out iset=I1 prefix14_class=3541
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P0, P1
cmovle S0, P1
cmovge S0, P0
cmovl P1, P0
cmp P1, P2
mov S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P3, S0
cmovge P0, P3
