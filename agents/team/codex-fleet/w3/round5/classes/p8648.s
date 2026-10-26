# n=5 model=out iset=I1 prefix14_class=8648
mov S0, P2
cmp S0, P0
mov S2, P1
cmovl P2, P0
cmovg S0, P0
cmp P3, P1
mov S1, P2
cmovl P1, P3
cmovl P3, S2
cmp S1, P3
cmovg S1, P3
cmovg P3, P2
cmp P1, S0
mov P3, S1
