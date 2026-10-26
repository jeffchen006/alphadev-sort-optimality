# n=5 model=out iset=I1 prefix14_class=1343
mov S1, P0
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
cmp P2, P3
mov S0, S1
cmovle S2, P2
cmovge S2, P3
cmovge P3, P2
cmp P3, S1
cmovl S0, P3
cmovge S1, P3
mov S1, S2
cmp S1, P1
