# n=5 model=out iset=I1 prefix14_class=4561
cmp P2, P0
cmovle S0, P2
cmovge S0, P0
cmovge P0, P2
cmp P3, P1
mov S1, P1
cmovg S1, P3
cmovg P3, P1
cmp P0, S1
cmovge S2, P0
cmovle S2, S1
cmovl S1, P0
cmp P3, S0
cmovge P0, P3
