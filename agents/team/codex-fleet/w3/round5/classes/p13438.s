# n=5 model=out iset=I1 prefix14_class=13438
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovg P1, S2
cmp P0, P3
cmovge S0, P0
cmovl S0, P3
cmovle P3, P0
cmp P3, P2
cmovl P0, P2
cmovle P2, P3
cmovl P3, P0
cmp P1, S0
mov P2, P1
