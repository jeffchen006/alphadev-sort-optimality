# n=5 model=out iset=I1 prefix14_class=12343
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovl P2, P3
mov S2, P0
cmp S2, S0
cmovg P0, S0
mov P0, P1
cmovl S2, S0
cmp P1, P2
