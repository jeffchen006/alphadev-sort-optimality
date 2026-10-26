# n=5 model=out iset=I1 prefix14_class=3161
mov S2, P1
cmp P1, P3
cmovg S2, P3
cmovg P3, P1
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
mov P1, S2
cmp P1, P2
cmovg S2, P2
cmovl P1, P2
mov P2, P3
mov S2, P1
