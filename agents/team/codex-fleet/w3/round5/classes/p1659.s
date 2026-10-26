# n=5 model=out iset=I1 prefix14_class=1659
mov S1, P1
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
cmp S1, P0
cmovg S1, P0
mov S0, P2
cmovge P0, P1
cmp S0, S1
cmovl P2, S1
cmovle S1, S0
cmp P3, P0
cmovge S2, P3
