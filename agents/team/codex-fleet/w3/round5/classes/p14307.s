# n=5 model=out iset=I1 prefix14_class=14307
mov S0, P3
cmp P2, S0
cmovl S0, P2
cmovg P3, P2
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovg S2, P1
cmp S2, S0
cmovge S1, S2
cmovg S2, S0
cmovge S0, S1
mov P1, S0
cmp P3, P0
