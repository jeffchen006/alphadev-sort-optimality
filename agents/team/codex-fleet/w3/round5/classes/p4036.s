# n=5 model=out iset=I1 prefix14_class=4036
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
mov S2, P0
cmp P3, P0
cmovg S2, P3
cmovle P0, P3
mov S0, P0
cmp P1, S0
cmovle P0, P1
cmovg S0, P1
cmp S2, P2
cmovl P0, S2
