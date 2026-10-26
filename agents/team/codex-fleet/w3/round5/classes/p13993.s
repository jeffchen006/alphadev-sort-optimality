# n=5 model=out iset=I1 prefix14_class=13993
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovl S1, P0
cmp P2, P3
mov S2, P2
