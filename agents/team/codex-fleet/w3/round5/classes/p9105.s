# n=5 model=out iset=I1 prefix14_class=9105
mov S0, P3
mov S2, P1
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmp S0, P0
mov S1, S2
cmovg P3, P0
cmovle S0, P0
cmp S2, P3
cmovl S1, P3
cmovl P3, S2
cmp P2, S0
cmovle S2, S1
