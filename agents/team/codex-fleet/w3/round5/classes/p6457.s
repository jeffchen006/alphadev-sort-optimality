# n=5 model=out iset=I1 prefix14_class=6457
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
cmp P2, P1
cmovge S0, P2
cmovl S0, P1
cmovge P2, P1
cmovge P1, S0
cmp P1, P0
cmovge S0, P0
mov S2, S0
cmovg P0, P1
cmp P2, P3
