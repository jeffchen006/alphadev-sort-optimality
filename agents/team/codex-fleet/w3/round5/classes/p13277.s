# n=5 model=out iset=I1 prefix14_class=13277
mov S0, P2
cmp S0, P3
cmovle P2, P3
cmovg S0, P3
cmp P0, P1
cmovge S1, P1
cmovl S1, P0
cmovge P1, P0
cmp S1, S0
cmovge P0, S1
cmovge S1, S0
cmovge S0, P0
cmp P2, P1
cmovge P3, P1
