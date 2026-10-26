# n=5 model=out iset=I1 prefix14_class=4138
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovge P2, P1
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
mov S2, S1
cmovg P0, P3
cmp S0, S1
cmovge S1, S0
cmovge S0, S2
cmp P2, P0
cmovl S2, P0
