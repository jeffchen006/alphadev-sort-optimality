# n=5 model=out iset=I1 prefix14_class=12910
mov S2, P3
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P1, S2
cmovg S2, P1
cmovl P3, P1
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmovle S0, P2
cmp P0, S2
cmovge S1, S2
