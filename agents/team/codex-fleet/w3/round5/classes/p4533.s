# n=5 model=out iset=I1 prefix14_class=4533
cmp P0, P2
cmovge S1, P0
cmovl S1, P2
cmovge P0, P2
mov S0, P1
cmp S0, P3
cmovge S0, P3
cmovle P1, P3
cmp S1, P1
cmovg S2, S1
cmovg S1, P1
cmovg P1, S2
cmp P0, S0
mov S2, P0
