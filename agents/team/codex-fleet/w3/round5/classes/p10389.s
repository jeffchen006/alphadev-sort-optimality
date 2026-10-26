# n=5 model=out iset=I1 prefix14_class=10389
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P3, P2
mov S1, P0
mov S0, P2
cmovge S0, P3
cmovge P3, P2
cmp S1, S0
cmovl S1, S0
cmovle S0, P0
cmp P3, P1
mov P0, P3
