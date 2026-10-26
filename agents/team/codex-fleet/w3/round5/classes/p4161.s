# n=5 model=out iset=I1 prefix14_class=4161
cmp P1, P2
cmovge S2, P2
cmovl S2, P1
cmovge P2, P1
cmp P0, P3
mov S1, P0
mov S0, S2
cmovl S1, P3
cmovle P3, P0
cmp P3, S0
cmovg S2, P3
cmovle S0, P3
cmp P2, S1
cmovle P0, S1
