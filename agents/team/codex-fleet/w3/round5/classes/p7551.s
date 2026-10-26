# n=5 model=out iset=I1 prefix14_class=7551
mov S2, P1
cmp P0, P1
mov S0, P3
cmovge S2, P0
cmovg P0, P1
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
cmp P0, P2
cmovle P3, P0
cmovle P0, P2
cmovl P2, P3
mov S1, S2
cmp S0, S1
