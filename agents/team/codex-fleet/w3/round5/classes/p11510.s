# n=5 model=out iset=I1 prefix14_class=11510
mov S1, P3
cmp P1, P0
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, S1
cmovl P3, P2
cmovle P2, S1
cmp P0, P3
mov S2, P3
cmovg S2, P0
cmovge P0, P3
cmp P2, P1
cmovge S0, P1
