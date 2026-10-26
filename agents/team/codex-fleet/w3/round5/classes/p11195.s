# n=5 model=out iset=I1 prefix14_class=11195
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
mov S2, P1
cmovge P0, S0
cmp P2, P3
cmovge S1, P2
cmovl S1, P3
cmovle P3, P2
cmp P1, S1
cmovg P1, S1
cmovl S2, S1
cmp P3, P0
cmovle S0, P0
