# n=5 model=out iset=I1 prefix14_class=8873
mov S1, P0
cmp S1, P2
cmovge P0, P2
cmovg P2, S1
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovge P1, P3
mov S0, P2
cmp S2, S0
cmovge P2, S2
cmovge S2, S0
cmp P0, P1
cmovle S0, P0
