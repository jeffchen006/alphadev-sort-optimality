# n=5 model=out iset=I1 prefix14_class=5087
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovge S1, P2
cmovg P2, P1
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
mov S2, P3
cmp S1, S2
cmovl P3, S1
cmovge S2, S1
cmp P0, P1
