# n=5 model=out iset=I1 prefix14_class=2233
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
cmovl S0, P0
cmovge S0, P2
mov S2, P3
cmovge P2, P0
cmp P3, S0
cmovle P3, S0
cmovl S0, S2
cmp P1, P2
mov S2, P2
