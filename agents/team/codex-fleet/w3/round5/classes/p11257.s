# n=5 model=out iset=I1 prefix14_class=11257
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovge P0, P2
mov S2, P1
cmp P3, P1
cmovge P1, P3
cmovg P3, S2
cmp S0, P1
mov S1, S0
cmovle S0, P1
cmovl P1, S1
cmp P3, P0
cmovge S0, P0
