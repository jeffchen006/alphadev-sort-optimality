# n=5 model=out iset=I1 prefix14_class=5054
mov S2, P1
cmp P3, S2
cmovl P1, P3
mov S0, P2
cmovg S2, P3
cmp P0, S0
cmovl S0, P0
cmovg P2, P0
mov S1, S0
cmp P1, S0
cmovle S0, P1
cmovg S1, P1
cmp S2, P2
mov S0, S1
