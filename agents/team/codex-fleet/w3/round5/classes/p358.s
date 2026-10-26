# n=5 model=out iset=I1 prefix14_class=358
cmp P2, P0
cmovle S0, P0
cmovge S0, P2
cmovg P2, P0
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
mov S2, P2
cmovg P3, S1
cmp P1, S2
cmovle S2, P1
mov S1, P3
cmovl P1, P2
cmp S0, S1
