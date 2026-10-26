# n=5 model=out iset=I1 prefix14_class=8396
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovg S1, P1
cmp P2, P0
cmovle S2, P0
mov S0, S1
cmovge S2, P2
cmovge P2, P0
cmp S1, S2
cmovg S1, S2
cmovle S0, S2
cmp P2, P3
cmovg P0, P2
