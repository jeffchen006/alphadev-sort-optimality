# n=5 model=out iset=I1 prefix14_class=6904
mov S0, P0
cmp P1, S0
cmovg P0, P1
cmovl S0, P1
cmp P3, P2
mov S2, P3
cmovge P3, P2
cmovle S2, P2
cmp P0, S2
cmovl S1, S2
cmovge S1, P0
cmovle S2, P0
cmp P3, S0
cmovle P1, S0
