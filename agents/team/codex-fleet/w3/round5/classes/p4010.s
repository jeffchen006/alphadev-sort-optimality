# n=5 model=out iset=I1 prefix14_class=4010
mov S2, P3
cmp P1, P0
mov S0, P1
cmovg S0, P0
cmovl P1, P0
cmp S2, P2
cmovg P3, P2
cmovg P2, S2
mov S1, S0
cmp S0, P3
cmovg S1, P3
cmovge P3, S0
cmp P1, P2
cmovg P0, P1
