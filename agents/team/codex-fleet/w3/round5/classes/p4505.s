# n=5 model=out iset=I1 prefix14_class=4505
mov S0, P2
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmovle S1, P1
cmp S0, P3
cmovl S0, P3
cmovge P2, P3
cmp S0, S1
cmovle P3, S0
cmovge P3, S1
cmovge S1, S0
cmp P2, P0
cmovge S1, P0
