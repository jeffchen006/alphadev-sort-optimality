# n=5 model=out iset=I1 prefix14_class=5969
mov S0, P1
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovg S1, P3
cmp S0, P2
cmovg P1, P2
cmovl S0, P2
mov S2, S1
cmp S0, S2
cmovl S2, S0
cmovle S0, S1
cmp P1, P0
cmovg P2, P0
