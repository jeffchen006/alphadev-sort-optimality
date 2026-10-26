# n=5 model=out iset=I1 prefix14_class=10892
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovge P3, P2
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovl P3, S0
cmp S2, P0
cmovle S0, P0
