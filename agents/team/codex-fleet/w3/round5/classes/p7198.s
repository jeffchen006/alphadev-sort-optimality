# n=5 model=out iset=I1 prefix14_class=7198
mov S1, P3
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
cmp S1, P0
cmovg S1, P0
mov S0, S1
cmovge P0, P3
cmp S1, P2
cmovg S0, P2
cmovl S1, P2
cmp P1, P0
cmovle S0, P1
