# n=5 model=out iset=I1 prefix14_class=4504
mov S0, P2
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmovle S1, P3
cmp S0, P1
cmovl S0, P1
cmovge P2, P1
cmp S0, S1
cmovle P1, S0
cmovge P1, S1
cmovge S1, S0
cmp P2, P0
cmovge S1, P0
