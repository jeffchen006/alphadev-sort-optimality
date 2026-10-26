# n=5 model=out iset=I1 prefix14_class=922
mov S0, P2
cmp P0, S0
cmovg S0, P0
mov S1, P1
mov S2, S0
cmovl P2, P0
cmp S1, P3
cmovg S1, P3
cmovg P3, P1
mov P0, S1
cmp P3, S0
cmovg S0, P3
cmovl S2, P3
cmovg P3, S2
