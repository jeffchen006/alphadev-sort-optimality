# n=5 model=out iset=I1 prefix14_class=7698
cmp P3, P2
mov S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
cmovle S2, P1
cmovg S2, P0
cmovg P0, P1
cmp S2, S1
cmovge S0, S2
cmovl S0, S1
cmovge S2, S1
cmp P2, P0
cmovg S2, P2
