# n=5 model=out iset=I1 prefix14_class=3194
mov S0, P2
cmp P0, P2
cmovl S0, P0
cmovge P2, P0
cmp P1, P3
cmovle S2, P1
cmovg S2, P3
cmovge P3, P1
cmp S0, S2
cmovge S1, S0
cmovg S0, S2
cmovle S1, S2
cmp P2, P3
cmovg P1, P3
