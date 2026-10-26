# n=5 model=out iset=I1 prefix14_class=10608
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovge P0, S1
mov S0, P1
cmp P3, S0
cmovl S0, P3
cmovg P1, P3
cmovle P3, P1
cmp P3, P0
cmovl P3, P0
cmovl P0, P1
cmp P2, S0
mov S2, P0
