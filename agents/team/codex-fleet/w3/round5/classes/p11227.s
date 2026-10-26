# n=5 model=out iset=I1 prefix14_class=11227
mov S1, P2
mov S2, P0
cmp S2, P1
cmovge P0, P1
cmovle S2, P1
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmp P3, S2
cmovle S0, S2
cmovl S2, P3
cmovl P3, S0
cmp P2, P0
cmovg S1, P2
