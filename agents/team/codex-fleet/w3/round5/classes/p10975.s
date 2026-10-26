# n=5 model=out iset=I1 prefix14_class=10975
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
mov S0, P0
cmp P3, P0
mov S2, P1
cmovge P0, P3
cmovl S0, P3
cmp P0, S2
cmovge S2, P0
cmovl P1, P0
cmp P2, S0
cmovle P0, S0
