# n=5 model=out iset=I1 prefix14_class=13468
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovge P3, S1
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
cmovge P1, P2
mov S2, P0
cmp S2, S0
cmovg P0, S0
cmovle S2, S0
mov P0, P3
cmp P0, P1
