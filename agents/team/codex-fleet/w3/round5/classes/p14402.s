# n=5 model=out iset=I1 prefix14_class=14402
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovl P0, P2
mov S1, P1
cmp S1, P3
cmovg P1, P3
cmovg P3, S1
cmp P1, S0
cmovl S2, S0
cmovl S0, P1
cmovl P1, S2
cmp P3, P0
cmovle S1, P3
