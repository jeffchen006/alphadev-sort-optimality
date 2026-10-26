# n=5 model=out iset=I1 prefix14_class=6105
cmp P1, P3
cmovge S2, P1
cmovle S2, P3
cmovl P3, P1
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
cmovle S1, P0
mov S0, S1
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
cmp P2, P3
cmovle S2, P2
