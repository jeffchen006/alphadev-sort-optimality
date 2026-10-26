# n=5 model=out iset=I1 prefix14_class=5585
mov S0, P1
cmp P2, S0
mov S2, P3
cmovg S0, P2
cmovl P1, P2
mov P2, P1
cmp S2, P0
cmovg S2, P0
cmovl P3, P0
cmp S2, P1
cmovg P1, S2
cmovl P2, S2
cmp P3, S0
cmovge P0, P3
