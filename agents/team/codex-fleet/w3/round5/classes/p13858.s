# n=5 model=out iset=I1 prefix14_class=13858
cmp P3, P1
cmovge S2, P3
cmovge P3, P1
cmovge P1, S2
mov S0, P0
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
cmp P1, P2
cmovg S1, P2
cmovle S1, P1
cmovg P2, P1
cmp S0, P3
cmovl S2, S0
