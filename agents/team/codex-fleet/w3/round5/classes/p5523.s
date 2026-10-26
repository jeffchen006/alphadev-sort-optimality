# n=5 model=out iset=I1 prefix14_class=5523
cmp P1, P3
mov S2, P1
cmovl P1, P3
mov S0, P2
cmovl P3, S2
cmp P2, P0
cmovg S0, P0
cmovl P2, P0
cmp S0, P3
mov S1, S0
cmovle S1, P3
cmovg S0, P3
cmp P1, P2
cmovl S0, P2
