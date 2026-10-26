# n=5 model=out iset=I1 prefix14_class=4397
mov S2, P3
cmp P0, S2
mov S0, P1
cmovge P3, P0
cmovge P0, S2
cmp P2, S0
cmovl S0, P2
cmovg P1, P2
mov P2, P1
cmp P3, P1
cmovge P2, P3
cmovge P3, P1
cmp P0, S0
cmovl P2, S0
