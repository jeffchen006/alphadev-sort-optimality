# n=5 model=out iset=I1 prefix14_class=8569
mov S2, P2
cmp P2, P3
cmovl S2, P3
cmovl P3, P2
cmp P0, P1
cmovg S0, P0
cmovle S0, P1
mov S1, S0
cmovg P0, P1
cmp S2, S0
cmovg S1, S2
mov S1, P3
cmovg S2, S0
cmp S1, P0
