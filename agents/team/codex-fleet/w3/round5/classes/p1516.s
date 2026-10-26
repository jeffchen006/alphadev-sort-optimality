# n=5 model=out iset=I1 prefix14_class=1516
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovle S0, P3
cmp P0, P1
cmovg S2, P1
cmovle S2, P0
cmovge P1, P0
mov P0, S0
cmp S0, S2
cmovg S0, S2
cmovge S2, P0
cmp P1, P2
cmovl S1, P1
