# n=5 model=out iset=I1 prefix14_class=11309
mov S2, P2
cmp S2, P1
cmovg S2, P1
cmovl P2, P1
cmp P0, P3
cmovg P1, P0
cmovg P0, P3
cmovg P3, P1
cmp P3, P2
mov S1, P3
mov S0, P0
cmovg S1, P2
cmovg P2, P3
cmp P0, S2
