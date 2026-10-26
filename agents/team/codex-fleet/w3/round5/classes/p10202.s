# n=5 model=out iset=I1 prefix14_class=10202
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
mov S0, P3
cmovge P0, S1
cmp P1, P3
mov S2, P0
cmovge P3, P1
cmovl S0, P1
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
mov P1, S0
cmp P2, P1
