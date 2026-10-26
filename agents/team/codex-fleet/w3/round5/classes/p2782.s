# n=5 model=out iset=I1 prefix14_class=2782
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovge P2, P1
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovg P0, P3
mov P1, S1
cmp S1, S2
cmovge P1, S2
cmovg S2, S1
cmp P2, P0
cmovl S0, P2
