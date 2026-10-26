# n=5 model=out iset=I1 prefix14_class=8014
mov S2, P1
cmp P3, S2
cmovge P1, P3
cmovg P3, S2
cmp P2, P0
cmovle S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovge S0, P3
cmp P2, P1
cmovle S1, P2
