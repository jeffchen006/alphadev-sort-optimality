# n=5 model=out iset=I1 prefix14_class=9195
cmp P3, P2
cmovle S2, P2
mov S0, P1
cmovg S2, P3
cmovge P3, P2
cmp P0, S0
cmovge P1, P0
cmovg P0, S0
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmovl S1, P3
cmp P1, S2
cmovg P3, S1
