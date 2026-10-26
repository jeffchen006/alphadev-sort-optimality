# n=5 model=out iset=I1 prefix14_class=7689
mov S0, P1
cmp P0, P1
cmovg P1, P0
cmovl S0, P0
mov S2, P3
cmp S2, P2
cmovle P3, P2
cmovl P2, S2
cmp S0, P2
cmovle S1, S0
cmovl S0, P2
cmovl P2, S1
cmp P3, P1
cmovl P2, P1
