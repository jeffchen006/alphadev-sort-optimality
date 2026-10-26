# n=5 model=out iset=I1 prefix14_class=2433
mov S2, P3
cmp P0, S2
cmovl S2, P0
cmovge P3, P0
cmp P1, P2
mov S1, P1
mov S0, P3
cmovl P1, P2
cmovle P2, S1
cmp P1, S0
cmovge P3, P1
cmovge P1, S0
mov P3, S2
cmp P2, S2
