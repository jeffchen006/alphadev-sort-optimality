# n=5 model=out iset=I1 prefix14_class=10223
mov S2, P3
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P1, S2
cmovg S2, P1
cmovge P1, P3
cmovge P3, S2
cmp P0, S2
cmovl S2, P0
cmovge P3, P0
cmp P1, P2
cmovge S0, P2
