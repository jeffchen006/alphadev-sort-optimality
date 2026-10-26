# n=5 model=out iset=I1 prefix14_class=7747
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
mov S0, P2
cmovge S1, P0
cmp P1, S0
cmovle S0, P1
cmovge P2, P1
cmp S0, S1
cmovge S2, S0
cmovge S0, S1
cmovle S2, S1
cmp P2, P3
cmovl P0, P2
