# n=5 model=out iset=I1 prefix14_class=5119
mov S0, P3
cmp P3, P1
cmovle P3, P1
cmovle P1, S0
cmp P0, P2
mov S0, P1
cmovge S2, P0
cmovl S2, P2
cmovge P0, P2
cmp P0, P1
cmovl P1, P0
cmovg S0, P0
mov S1, S0
cmp P3, S2
