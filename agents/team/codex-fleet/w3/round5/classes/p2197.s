# n=5 model=out iset=I1 prefix14_class=2197
cmp P0, P3
mov S1, P0
mov S0, P1
cmovge P0, P3
cmovl S1, P3
cmp P2, S0
cmovge P1, P2
mov S2, P1
cmovge P2, S0
cmp P1, S1
cmovl P1, S1
cmovle S1, S2
cmp P2, P0
cmovg S2, P0
