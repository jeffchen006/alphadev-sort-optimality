# n=5 model=out iset=I1 prefix14_class=3741
mov S0, P0
cmp P3, S0
cmovl S0, P3
cmovg P0, P3
mov P3, P0
cmp P1, P2
cmovg S1, P2
cmovg P2, P1
mov S2, S0
cmovg P1, S1
cmp P1, S0
cmovl S2, P1
cmovg S0, P1
cmp P3, P2
