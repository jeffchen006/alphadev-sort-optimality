# n=5 model=out iset=I1 prefix14_class=6855
mov S2, P3
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp S2, P1
cmovle S2, P1
cmovl P1, P3
mov S1, S2
cmp P0, S1
cmovg S2, P0
cmovl S1, P0
cmp P2, P1
cmovg P0, P1
