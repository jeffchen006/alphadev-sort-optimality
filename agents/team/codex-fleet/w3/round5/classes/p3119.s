# n=5 model=out iset=I1 prefix14_class=3119
mov S0, P2
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
cmovge P0, P3
mov S2, S1
cmp P1, S0
cmovg P2, P1
cmovl S0, P1
cmp S2, S0
cmovge S1, S0
cmovle S2, S0
mov S1, S2
mov S0, P2
