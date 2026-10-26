# n=5 model=out iset=I1 prefix14_class=10374
mov S1, P1
mov S0, P0
cmp P0, P3
cmovl P0, P3
cmovle P3, S0
cmp P1, P2
cmovle P1, P2
cmovge S1, P2
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P3, S1
cmovg S2, P3
