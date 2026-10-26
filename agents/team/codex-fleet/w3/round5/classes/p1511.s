# n=5 model=out iset=I1 prefix14_class=1511
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovge P2, P3
cmp P0, P1
cmovle S2, P0
cmovg S2, P1
cmovg P1, P0
cmp S0, S2
mov P0, S0
cmovg S0, S2
cmovg S2, P0
cmp P1, P2
cmovge S1, P2
