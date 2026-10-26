# n=5 model=out iset=I1 prefix14_class=8792
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovle P2, P0
mov S0, P3
cmp P1, P3
cmovge S0, P1
cmovl P3, P1
cmp P2, S0
cmovge S2, P2
cmovge P2, S0
cmovg S0, S2
mov P1, S1
cmp P1, P3
