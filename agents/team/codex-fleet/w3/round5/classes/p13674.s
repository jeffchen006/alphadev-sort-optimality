# n=5 model=out iset=I1 prefix14_class=13674
cmp P3, P0
cmovl S1, P0
mov S0, P1
cmovle P0, P3
cmovl P3, S1
cmp P2, S0
cmovge P1, P2
cmovge P2, S0
cmp P3, P1
cmovg S2, P3
cmovle S2, P1
cmovge P3, P1
mov P1, P0
cmp P1, P2
