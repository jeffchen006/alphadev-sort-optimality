# n=5 model=out iset=I1 prefix14_class=5814
cmp P0, P1
cmovg S1, P1
cmovle S1, P0
mov S2, S1
cmovl P0, P1
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp S2, P2
cmovg S1, P2
cmovl S2, P2
mov P1, P3
cmp P0, P3
