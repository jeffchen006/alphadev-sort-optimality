# n=5 model=out iset=I1 prefix14_class=3725
cmp P3, P2
mov S2, P1
mov S1, P2
cmovge S1, P3
cmovle P2, P3
cmp P0, S2
cmovge S2, P0
cmovg P0, P1
cmp P0, P2
cmovge P1, P0
cmovl P1, P2
cmovle P2, P0
cmp S1, S2
cmovg S0, S2
