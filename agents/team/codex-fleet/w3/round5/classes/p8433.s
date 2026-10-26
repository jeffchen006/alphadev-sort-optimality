# n=5 model=out iset=I1 prefix14_class=8433
mov S1, P2
cmp P0, S1
cmovl S1, P0
cmovge P2, P0
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
cmovle P1, P3
cmp P2, S0
mov S2, P2
cmovge S2, S0
cmovle P2, S0
cmp S1, P1
cmovge P2, S1
