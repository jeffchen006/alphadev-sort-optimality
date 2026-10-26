# n=5 model=out iset=I1 prefix14_class=9554
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovg S0, P0
mov S1, P3
cmp S1, P1
cmovl P3, P1
cmovg S1, P1
mov S2, S1
cmp S0, S1
cmovge S2, S0
cmovle S1, S0
cmp P3, P2
cmovge P1, P2
