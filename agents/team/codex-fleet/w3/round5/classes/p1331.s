# n=5 model=out iset=I1 prefix14_class=1331
cmp P3, P1
cmovge S1, P3
cmovle S1, P1
cmovle P1, P3
mov S2, P2
cmp P2, P0
mov P3, S1
cmovg S2, P0
cmovg P0, P2
cmp P0, S1
cmovge P3, P0
cmovl S1, P0
cmp P1, S2
cmovge S0, S2
