# n=5 model=out iset=I1 prefix14_class=1757
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P0, P2
cmovl S0, P2
mov S2, P3
cmovle P2, P0
cmovl P0, S0
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
cmp P3, P2
