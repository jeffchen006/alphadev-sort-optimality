# n=5 model=out iset=I1 prefix14_class=9111
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
mov S2, P3
cmp P3, S1
cmovl S2, S1
cmovl S1, P3
cmp P1, P0
cmovge S0, P1
