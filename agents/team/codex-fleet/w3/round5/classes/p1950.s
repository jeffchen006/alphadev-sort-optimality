# n=5 model=out iset=I1 prefix14_class=1950
cmp P2, P1
mov S1, P3
cmovge S0, P1
cmovle S0, P2
cmovl P2, P1
cmp P0, S1
cmovg S1, P0
cmovle P3, P0
mov S2, P2
cmp S1, S2
cmovge P2, S1
cmovl S2, S1
cmp S0, P3
cmovge P0, P3
