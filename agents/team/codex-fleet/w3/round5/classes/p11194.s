# n=5 model=out iset=I1 prefix14_class=11194
cmp P0, P1
cmovge S0, P1
mov S1, P2
cmovg P1, P0
cmovg P0, S0
mov S2, P1
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
cmp S2, S1
cmovle P1, S1
cmovg S2, S1
cmp P3, P0
cmovge P2, P3
