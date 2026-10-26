# n=5 model=out iset=I1 prefix14_class=1287
mov S0, P1
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
mov S2, P3
cmovg P0, S1
cmp S0, P2
cmovle P1, P2
cmovl P2, S0
cmp S2, P1
cmovle P3, P1
cmovg S2, P1
cmp P0, P2
mov P3, P0
