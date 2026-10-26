# n=5 model=out iset=I1 prefix14_class=10425
cmp P3, P0
cmovl S0, P0
cmovge S0, P3
mov S1, P1
cmovle P0, P3
cmp P2, S1
mov S2, S0
cmovle S1, P2
cmovle P2, P1
cmp P2, S2
cmovge S0, P2
cmovle S2, P2
cmp P0, S1
cmovge P3, S1
