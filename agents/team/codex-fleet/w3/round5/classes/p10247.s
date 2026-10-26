# n=5 model=out iset=I1 prefix14_class=10247
cmp P0, P3
cmovle S0, P0
cmovg S0, P3
mov S2, P1
cmovle P0, P3
cmp P1, P2
cmovl S2, P2
cmovl P2, P1
cmp P0, S2
cmovge P3, P0
mov S1, S0
cmovge P0, S2
mov P1, P0
cmovg S2, P3
