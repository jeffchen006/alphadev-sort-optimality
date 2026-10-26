# n=5 model=out iset=I1 prefix14_class=1790
cmp P3, P1
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
mov S0, P1
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
cmovge P0, P2
cmp S0, S1
cmovle S0, S1
cmovge P1, S1
cmp P3, P0
mov S0, P0
