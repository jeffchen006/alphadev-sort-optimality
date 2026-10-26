# n=5 model=out iset=I1 prefix14_class=14373
mov S0, P3
cmp P3, P2
mov S1, P0
cmovl S0, P2
cmovle P2, P3
cmp P0, P1
cmovge P0, P1
cmovge P1, S1
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovg P0, S2
cmp P1, S0
cmovge S1, S0
