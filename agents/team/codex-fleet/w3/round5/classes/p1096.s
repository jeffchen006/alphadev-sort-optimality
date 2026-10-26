# n=5 model=out iset=I1 prefix14_class=1096
mov S0, P3
cmp S0, P2
cmovl P3, P2
mov S2, P3
cmovl P2, S0
mov S1, P0
cmp P0, P1
cmovg P0, P1
cmovle S1, P1
cmp P3, S1
cmovle S2, S1
cmovl S1, P3
mov P3, P0
cmp P2, P0
