# n=5 model=out iset=I1 prefix14_class=11199
cmp P2, P3
cmovge S0, P3
mov S1, P1
cmovg P3, P2
cmovge P2, S0
cmp P1, P0
cmovle S1, P0
mov S2, S1
cmovle P0, P1
cmp P3, S2
cmovg S2, P3
cmovl S1, P3
cmovge P3, S1
mov P1, P0
