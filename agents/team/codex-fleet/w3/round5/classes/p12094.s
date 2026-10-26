# n=5 model=out iset=I1 prefix14_class=12094
mov S0, P1
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovg P2, S1
cmp P3, S0
cmovl S0, P3
cmovl P3, P1
cmp S0, P2
cmovl P1, P2
cmovl P2, S0
cmovl S0, P1
cmp P0, P3
cmovle S1, P0
