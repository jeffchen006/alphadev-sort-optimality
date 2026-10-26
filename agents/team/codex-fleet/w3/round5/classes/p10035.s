# n=5 model=out iset=I1 prefix14_class=10035
mov S2, P2
cmp P2, P1
cmovg S2, P1
cmovl P2, P1
cmp P0, P3
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P2
cmp P3, P2
cmovl P2, P3
cmovg S1, P3
mov S1, P0
cmp S2, S1
