# n=5 model=out iset=I1 prefix14_class=6623
mov S0, P0
mov S1, P3
cmp P2, P0
cmovge P0, P2
cmovle S0, P2
cmp S1, P1
cmovg S1, P1
cmovl P3, P1
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovge P3, S2
cmp S1, S0
cmovge S2, S1
