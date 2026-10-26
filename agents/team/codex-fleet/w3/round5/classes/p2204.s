# n=5 model=out iset=I1 prefix14_class=2204
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovle S2, P3
mov S0, P2
cmp P1, P2
cmovge P2, P1
cmovge P1, S0
mov P3, P2
cmp P2, S2
cmovle P3, S2
cmovl S2, P2
cmp P1, P0
cmovge S1, P0
