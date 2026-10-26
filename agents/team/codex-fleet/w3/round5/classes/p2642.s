# n=5 model=out iset=I1 prefix14_class=2642
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov S0, P0
cmovg P3, S2
cmp P1, P0
cmovl S0, P1
mov S2, P3
cmovg P0, P1
cmp P0, S2
cmovle S2, P0
cmovl P0, P3
cmp S0, P2
cmovl P0, S0
