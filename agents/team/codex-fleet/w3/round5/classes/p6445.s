# n=5 model=out iset=I1 prefix14_class=6445
mov S1, P2
cmp P1, S1
cmovle P2, P1
mov S0, P3
cmovge S1, P1
cmp P0, P3
cmovge P3, P0
cmovl S0, P0
cmovl P0, P3
cmp P0, S1
cmovl P0, S1
cmovl S1, P3
cmp P2, S0
cmovle P3, S1
