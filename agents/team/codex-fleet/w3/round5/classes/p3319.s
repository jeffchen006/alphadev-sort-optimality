# n=5 model=out iset=I1 prefix14_class=3319
mov S2, P3
cmp P2, S2
cmovg S2, P2
mov S0, P0
cmovle P3, P2
cmp P0, P1
cmovg S0, P1
mov S1, S0
cmovge P1, P0
cmp P3, S0
cmovl S1, P3
cmovl P3, S0
cmp S2, P1
mov S1, P1
