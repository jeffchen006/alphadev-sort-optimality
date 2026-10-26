# n=5 model=out iset=I1 prefix14_class=3238
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovl P1, P0
mov S1, P2
cmp P3, S1
cmovle S1, P3
cmovg P2, P3
mov S2, P2
cmp S1, P1
cmovge P0, P1
cmovg P1, S1
cmovge S1, P0
cmp S0, S2
