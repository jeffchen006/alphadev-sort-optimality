# n=5 model=out iset=I1 prefix14_class=12260
mov S1, P0
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovge P2, P3
cmp P1, P0
mov S0, S2
cmovge S1, P1
cmovge P1, P0
cmp S0, P1
cmovle S0, P1
cmovg S2, P1
cmp S1, P2
cmovle P1, S0
