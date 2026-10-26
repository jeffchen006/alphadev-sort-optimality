# n=5 model=out iset=I1 prefix14_class=8898
cmp P2, P1
mov S1, P2
cmovl S1, P1
mov S2, P0
cmovg P2, P1
cmp P3, S2
cmovl P0, P3
cmovl P3, S2
cmp S1, P3
mov S2, P0
cmovle S0, S1
cmovl S1, P3
cmovl P3, S0
cmp P0, P2
