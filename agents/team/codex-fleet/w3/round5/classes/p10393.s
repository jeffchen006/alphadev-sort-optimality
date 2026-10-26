# n=5 model=out iset=I1 prefix14_class=10393
mov S2, P1
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P1, P2
mov S1, P0
cmovge P1, P2
cmovle S2, P2
cmp P0, S2
cmovle S1, S2
cmovl S2, P0
cmp P1, P3
cmovge P2, P1
