# n=5 model=out iset=I1 prefix14_class=13175
cmp P2, P0
cmovle S2, P2
mov S0, P3
cmovle P2, P0
cmovle P0, S2
cmp P1, P3
cmovl S0, P1
cmovge P3, P1
cmp P0, S0
cmovle S1, S0
cmovl S0, P0
cmovg S1, P0
cmp P2, P3
cmovge S2, P3
