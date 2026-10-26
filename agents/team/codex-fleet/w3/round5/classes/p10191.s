# n=5 model=out iset=I1 prefix14_class=10191
cmp P1, P0
cmovg S1, P1
mov S0, P2
cmovge P1, P0
cmovg P0, S1
cmp P3, S0
cmovl P2, P3
cmovge S0, P3
cmp P0, S0
cmovl S1, P0
cmovle P0, S0
cmovl S0, S1
cmp P2, P1
cmovge S2, P1
