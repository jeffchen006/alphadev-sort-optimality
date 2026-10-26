# n=5 model=out iset=I1 prefix14_class=7606
cmp P2, P0
mov S1, P2
cmovle P2, P0
cmovle P0, S1
cmp P3, P1
cmovl S0, P3
cmovge S0, P1
cmovge P1, P3
cmp P0, S0
mov P3, S0
cmovge S0, P0
cmovle P3, P0
cmp P2, P1
cmovl P0, P2
