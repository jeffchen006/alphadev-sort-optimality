# n=5 model=out iset=I1 prefix14_class=10881
mov S2, P3
cmp P3, P1
cmovg S2, P1
cmovl P3, P1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovge P0, S0
cmp P2, P3
cmovle S1, P2
cmovg S1, P3
cmovge P3, P2
cmp S2, P0
cmovl P2, P0
