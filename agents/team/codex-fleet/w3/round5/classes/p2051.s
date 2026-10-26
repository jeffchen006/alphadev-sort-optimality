# n=5 model=out iset=I1 prefix14_class=2051
cmp P2, P0
cmovge S1, P0
cmovle S1, P2
mov S0, P1
cmovge P0, P2
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmp P3, P0
mov S2, P3
cmovg S2, P0
cmovl P3, P0
cmp S1, S0
cmovg P0, S2
