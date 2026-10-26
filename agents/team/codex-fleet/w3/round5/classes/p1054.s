# n=5 model=out iset=I1 prefix14_class=1054
mov S1, P3
mov S0, P0
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
cmp S1, P1
cmovge S1, P1
cmovg P1, P3
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, S1
mov S2, S1
