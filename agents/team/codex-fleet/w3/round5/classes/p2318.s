# n=5 model=out iset=I1 prefix14_class=2318
mov S0, P3
cmp P3, P2
cmovge S0, P2
cmovle P3, P2
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovge P0, P1
cmp P3, S1
cmovle S2, S1
cmovl S1, P3
cmovg S2, P3
cmp S0, P0
cmovge P3, S0
