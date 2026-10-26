# n=5 model=out iset=I1 prefix14_class=1951
cmp P2, P1
mov S0, P1
cmovl S0, P2
mov S1, P3
cmovle P2, P1
cmp P0, S1
cmovl P3, P0
cmovge S1, P0
mov S2, P2
cmp S1, S2
cmovge P2, S1
cmovle S2, S1
cmp P3, S0
cmovge P0, S0
