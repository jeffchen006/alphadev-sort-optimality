# n=5 model=out iset=I1 prefix14_class=508
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovl S1, P3
mov S0, P2
cmp P2, P1
cmovg P2, P1
cmovge P1, S0
mov S2, S1
cmp P2, S2
cmovle S1, P2
cmovle P2, S2
cmp P1, P0
cmovge S0, P1
