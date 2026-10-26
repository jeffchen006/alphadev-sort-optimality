# n=5 model=out iset=I1 prefix14_class=957
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovl P2, P0
cmp P3, P1
mov S1, S0
cmovge S2, P3
cmovg P3, P1
cmovge P1, S2
cmp P1, S1
cmovge S0, P1
cmovg P1, S1
cmp P3, P2
cmovl P0, P3
