# n=5 model=out iset=I1 prefix14_class=10189
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
mov S1, P0
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
cmovge P3, S0
cmp P3, S1
cmovg S1, P3
cmovl P0, P3
mov S1, P0
cmp P1, P2
