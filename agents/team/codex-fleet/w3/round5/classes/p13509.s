# n=5 model=out iset=I1 prefix14_class=13509
cmp P3, P0
mov S2, P0
mov S0, P2
cmovle S2, P3
cmovl P3, P0
cmp P1, S0
cmovle S0, P1
cmovg P2, P1
cmp S2, S0
mov S1, P2
cmovl P0, S2
cmovle S2, S0
cmovl S0, P0
cmp P3, S1
