# n=5 model=out iset=I1 prefix14_class=10984
mov S2, P3
cmp S2, P0
mov S1, P1
cmovg S2, P0
cmovg P0, P3
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmp S1, P0
cmovl S0, S1
cmovle S1, P0
cmovl P0, S0
cmp S2, P2
cmovl S0, P2
