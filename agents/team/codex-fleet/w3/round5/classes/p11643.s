# n=5 model=out iset=I1 prefix14_class=11643
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovle S2, P1
mov S0, S2
cmp P3, P0
cmovge S1, P3
cmovg P3, P0
cmovge P0, S1
cmp S0, P0
cmovle S2, P0
cmovge S0, P0
cmp P2, P3
cmovl P0, S0
