# n=5 model=out iset=I1 prefix14_class=4712
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
cmovge S2, P2
cmp P3, P0
cmovge S1, P3
cmovg P3, P0
cmovl S1, P0
mov S0, P1
cmp S1, S0
cmovg S0, S1
cmovg S1, P1
cmp P3, S2
cmovge P0, P3
