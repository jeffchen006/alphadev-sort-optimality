# n=5 model=out iset=I1 prefix14_class=3561
cmp P1, P2
mov S1, P1
cmovle P1, P2
mov S0, P3
cmovle P2, S1
mov S2, P1
cmp P0, P3
cmovl P3, P0
cmovge S0, P0
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovg P2, S1
cmp S0, S2
