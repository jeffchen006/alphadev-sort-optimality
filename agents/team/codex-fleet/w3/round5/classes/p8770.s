# n=5 model=out iset=I1 prefix14_class=8770
cmp P0, P3
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
mov S1, P2
cmp P1, P2
cmovl P2, P1
cmovg S1, P1
cmp P0, S1
mov S0, P0
cmovg P0, S1
cmovg S1, S0
cmp P3, P2
cmovge S1, P3
