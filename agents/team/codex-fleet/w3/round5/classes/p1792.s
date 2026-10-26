# n=5 model=out iset=I1 prefix14_class=1792
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P2, P0
mov S1, P1
cmovle S2, P0
cmovge S2, P2
cmovg P2, P0
cmp P1, S2
cmovge S1, S2
cmovl P1, S2
mov S2, P2
cmp P3, P2
