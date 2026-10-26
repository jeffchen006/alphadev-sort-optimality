# n=5 model=out iset=I1 prefix14_class=877
cmp P0, P2
mov S0, P0
cmovl P0, P2
mov S2, P3
cmovg S0, P2
cmp P3, P1
cmovge P3, P1
cmovge P1, S2
cmp P1, P0
mov P2, P0
cmovge P0, P1
mov P0, P3
cmovl P2, P1
cmp P0, S0
