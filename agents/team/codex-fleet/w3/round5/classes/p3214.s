# n=5 model=out iset=I1 prefix14_class=3214
mov S0, P2
mov S2, P1
cmp P3, S0
cmovle P2, P3
cmovge S0, P3
cmp P0, S2
cmovl P1, P0
cmovg S2, P0
mov P0, P2
cmp P1, P2
cmovg P2, P1
cmovge P1, P0
cmp S0, S2
cmovge S1, S2
