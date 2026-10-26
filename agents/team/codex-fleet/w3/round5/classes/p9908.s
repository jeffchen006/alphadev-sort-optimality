# n=5 model=out iset=I1 prefix14_class=9908
cmp P0, P3
cmovg S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P2, P1
cmovl S1, P1
cmovge S1, P2
mov S0, S1
cmovle P1, P2
cmp S1, P3
cmovl S1, P3
cmovg S0, P3
mov P3, P1
cmp P1, P0
