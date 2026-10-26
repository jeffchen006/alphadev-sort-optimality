# n=5 model=out iset=I1 prefix14_class=507
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
mov S0, P2
cmovl S1, P3
cmp P2, P1
cmovge P2, P1
cmovge P1, S0
mov S2, S1
cmp P2, S2
cmovl S1, P2
cmovle P2, S2
cmp P0, P1
mov S2, P0
