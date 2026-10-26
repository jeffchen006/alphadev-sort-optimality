# n=5 model=out iset=I1 prefix14_class=5080
cmp P2, P0
cmovl S0, P2
cmovle P2, P0
cmovge S0, P0
mov S2, P1
cmp S2, P3
cmovg S2, P3
cmovge P3, P1
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
cmovl S1, S0
cmp P2, P3
cmovg P1, P2
