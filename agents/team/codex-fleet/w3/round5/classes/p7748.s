# n=5 model=out iset=I1 prefix14_class=7748
cmp P3, P0
mov S2, P3
cmovl P3, P0
cmovge S2, P0
mov S0, P2
cmp P1, S0
cmovg P2, P1
cmovle S0, P1
cmp S0, S2
cmovge S1, S0
cmovge S0, S2
cmovle S1, S2
cmp P2, P3
cmovge P0, P3
