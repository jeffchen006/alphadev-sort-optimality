# n=5 model=out iset=I1 prefix14_class=7933
cmp P3, P1
mov S0, P1
cmovge S0, P3
cmovl P1, P3
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
cmovg P2, P0
cmp P1, S1
mov S2, P2
cmovge P0, S1
cmovge S1, P1
cmovg P1, P0
cmp P2, S0
