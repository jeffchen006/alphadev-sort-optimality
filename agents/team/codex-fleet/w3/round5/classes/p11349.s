# n=5 model=out iset=I1 prefix14_class=11349
mov S2, P3
cmp P2, P3
cmovge P3, P2
cmovg P2, S2
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
cmovge S2, P1
cmp P3, S2
cmovle S1, P3
cmovle P3, S2
mov S0, P0
cmovl S2, S1
cmp P2, S0
