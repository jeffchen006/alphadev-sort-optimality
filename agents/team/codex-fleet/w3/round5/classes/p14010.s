# n=5 model=out iset=I1 prefix14_class=14010
mov S1, P3
cmp P3, P2
cmovge P3, P2
cmovg P2, S1
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
mov S0, P1
cmovl P0, S1
mov S2, P0
cmp P2, P1
cmovl P1, P2
cmovge S0, P2
cmp P3, P0
