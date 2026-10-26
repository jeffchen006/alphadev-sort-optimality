# n=5 model=out iset=I1 prefix14_class=8871
cmp P0, P2
mov S1, P0
cmovge P0, P2
cmovge P2, S1
cmp P3, P1
cmovl S2, P1
cmovge S2, P3
cmovge P3, P1
mov S0, P2
cmp S2, S0
cmovge P2, S2
cmovge S2, S0
cmp P0, P3
cmovle S1, P0
