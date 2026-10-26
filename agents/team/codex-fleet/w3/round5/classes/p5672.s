# n=5 model=out iset=I1 prefix14_class=5672
cmp P0, P3
cmovl S2, P0
cmovge S2, P3
mov S0, S2
mov S1, P1
cmovge P3, P0
cmp P2, S1
cmovg P1, P2
cmovl S1, P2
cmp S1, S0
cmovle S0, S1
cmovl S1, S2
cmp P3, P1
cmovge S2, P1
