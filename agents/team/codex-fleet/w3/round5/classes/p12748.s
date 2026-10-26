# n=5 model=out iset=I1 prefix14_class=12748
cmp P3, P1
cmovge S2, P1
mov S0, P2
cmovge P1, P3
cmovle S2, P3
cmp S0, P0
cmovl P2, P0
cmovl P0, S0
cmp P0, S2
cmovg S1, S2
cmovg S2, P0
cmovle S1, P0
cmp P2, P1
cmovl P3, P1
