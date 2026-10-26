# n=5 model=out iset=I1 prefix14_class=5285
cmp P2, P1
mov S2, P3
cmovg S0, P2
cmovge P2, P1
cmovle S0, P1
cmp P0, S2
cmovle S2, P0
cmovl P0, P3
cmp P2, S2
mov P1, S2
cmovl S2, P2
cmovl P2, P1
mov S2, P2
mov S1, P0
