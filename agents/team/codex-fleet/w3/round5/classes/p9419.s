# n=5 model=out iset=I1 prefix14_class=9419
cmp P3, P2
cmovge S0, P2
mov S1, P0
cmovge P2, P3
cmovg P3, S0
cmp P1, S1
cmovl P0, P1
cmovl P1, S1
mov S1, P0
cmp P0, P3
cmovge P0, P3
cmovge P3, S1
cmp P2, P1
mov S1, P1
