# n=5 model=out iset=I1 prefix14_class=2103
mov S0, P1
cmp P2, P1
cmovl P1, P2
cmovg S0, P2
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovge P3, P0
cmp S0, S2
mov S1, S2
cmovge S2, S0
mov S2, P3
cmovg S0, S1
cmp S2, P1
