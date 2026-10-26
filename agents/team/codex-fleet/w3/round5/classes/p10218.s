# n=5 model=out iset=I1 prefix14_class=10218
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovge S0, P0
mov S2, P1
cmp P1, P3
cmovl P1, P3
cmovge S2, P3
cmp P1, P2
cmovg S1, P2
cmovg P2, P1
cmovle S1, P1
cmp S2, S0
cmovge P2, S0
