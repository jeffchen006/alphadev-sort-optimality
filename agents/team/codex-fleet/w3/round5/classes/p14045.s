# n=5 model=out iset=I1 prefix14_class=14045
mov S2, P2
cmp S2, P1
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovge P3, S2
mov S0, P3
mov S1, P2
cmp P1, S0
cmovl P3, P1
cmovle P1, S0
mov S0, P3
