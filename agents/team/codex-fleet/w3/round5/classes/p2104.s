# n=5 model=out iset=I1 prefix14_class=2104
cmp P0, P1
cmovle S0, P1
cmovg S0, P0
cmovl P1, P0
cmp P3, P2
cmovge S2, P3
cmovle S2, P2
cmovg P3, P2
cmp S0, S2
cmovge S1, S2
cmovge S2, S0
mov S2, P3
cmovge S0, S1
cmp P3, P1
