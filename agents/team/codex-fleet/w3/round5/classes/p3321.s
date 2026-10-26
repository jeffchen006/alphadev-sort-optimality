# n=5 model=out iset=I1 prefix14_class=3321
mov S2, P3
cmp P2, S2
cmovg S2, P2
mov S0, P1
cmovle P3, P2
cmp S0, P0
cmovg P1, P0
cmovge P0, S0
cmp P3, P1
mov S1, P1
cmovl S1, P3
cmovle P3, P1
cmp P0, S2
mov S1, S2
