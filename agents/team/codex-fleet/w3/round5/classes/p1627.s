# n=5 model=out iset=I1 prefix14_class=1627
mov S0, P0
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
cmp P2, P0
cmovl S0, P2
cmovge P0, P2
mov S2, S0
cmp P1, S0
cmovle S0, P1
cmovle P1, S2
cmp S1, P0
cmovge P3, S1
