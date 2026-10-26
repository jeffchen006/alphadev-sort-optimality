# n=5 model=out iset=I1 prefix14_class=3543
cmp P3, P1
mov S0, P3
cmovle P3, P1
cmovl P1, S0
mov S2, P1
cmp P2, P0
mov S0, P2
cmovle S0, P0
cmovl P0, P2
cmp P0, P1
cmovl S2, P0
cmovge P1, P0
cmp P3, S0
cmovge S2, P3
