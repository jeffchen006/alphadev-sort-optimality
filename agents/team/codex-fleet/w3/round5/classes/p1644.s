# n=5 model=out iset=I1 prefix14_class=1644
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
mov S0, P1
cmovl S1, P2
cmp P3, P1
cmovle P1, P3
cmovg S0, P3
mov S2, P1
cmp S2, P0
cmovl P1, P0
cmovg S2, P0
mov S2, S0
cmp S0, S1
