# n=5 model=out iset=I1 prefix14_class=7028
mov S1, P2
cmp P0, S1
cmovge S1, P0
cmovge P0, P2
mov S0, P1
cmp P1, P3
cmovge P1, P3
mov S2, P1
cmovle S0, P3
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmp S1, S0
cmovle P3, S0
