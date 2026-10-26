# n=5 model=out iset=I1 prefix14_class=6426
cmp P1, P0
mov S0, P1
cmovge P1, P0
mov S2, P3
cmovge P0, S0
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
mov S1, S2
cmp P0, S1
cmovge S2, P0
cmovle S1, P0
cmp P3, P1
cmovl S2, P3
