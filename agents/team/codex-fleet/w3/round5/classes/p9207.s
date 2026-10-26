# n=5 model=out iset=I1 prefix14_class=9207
mov S2, P3
cmp P1, S2
mov S0, P2
cmovl S2, P1
cmovle P1, P3
cmp P0, P2
cmovg P2, P0
cmovl S0, P0
cmp S0, S2
cmovge S1, S0
cmovg S0, S2
cmovge S2, S1
mov P0, S2
mov S0, P2
