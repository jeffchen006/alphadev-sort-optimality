# n=5 model=out iset=I1 prefix14_class=6663
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovge P1, P2
cmp S1, S0
cmovg S2, S0
cmovle S2, S1
cmovge S0, S1
cmp P0, P1
cmovl S1, P0
