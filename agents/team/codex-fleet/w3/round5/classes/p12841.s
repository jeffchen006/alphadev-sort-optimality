# n=5 model=out iset=I1 prefix14_class=12841
cmp P2, P0
cmovge S1, P2
cmovle S1, P0
cmovge P2, P0
mov S0, P1
cmp S0, P3
cmovle P1, P3
cmovg S0, P3
cmp S0, P2
cmovle S2, S0
cmovg S2, P2
cmovge P2, S0
cmp S1, P1
cmovl S0, S1
