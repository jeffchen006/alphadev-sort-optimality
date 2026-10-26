# n=5 model=out iset=I1 prefix14_class=3542
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovl P2, S0
mov S2, P2
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovl P0, P1
cmp P0, P2
cmovl S2, P0
cmovge P2, P0
cmp P3, S0
cmovge S2, P3
