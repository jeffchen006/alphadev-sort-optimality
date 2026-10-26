# n=5 model=out iset=I1 prefix14_class=359
cmp P2, P3
cmovle S0, P3
cmovge S0, P2
cmovg P2, P3
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
mov S2, P2
cmovg P0, S1
cmp P1, S2
cmovle S2, P1
mov S1, P0
cmovl P1, P2
cmp S0, S1
