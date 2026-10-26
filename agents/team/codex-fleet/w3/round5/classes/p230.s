# n=5 model=out iset=I1 prefix14_class=230
cmp P0, P2
mov S0, P1
cmovge S2, P0
cmovle S2, P2
cmovl P2, P0
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmp S0, P2
cmovge S1, S0
cmovle S1, P2
cmovl P2, S0
cmp P3, S2
cmovge P0, P3
