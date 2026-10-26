# n=5 model=out iset=I1 prefix14_class=12832
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovl P2, P3
mov S0, S2
cmp P1, P0
cmovg S1, P0
cmovge P0, P1
cmovle S1, P1
cmp S2, S1
cmovg S2, S1
cmovge S1, S0
cmp P0, P2
cmovl P1, P2
