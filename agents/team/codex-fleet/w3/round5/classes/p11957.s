# n=5 model=out iset=I1 prefix14_class=11957
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovle S0, P1
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P2, S1
cmovge P0, P2
cmovg P2, S1
mov S2, S0
cmovge S1, P0
cmp S2, P3
