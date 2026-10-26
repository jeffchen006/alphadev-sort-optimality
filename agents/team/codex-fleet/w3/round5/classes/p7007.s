# n=5 model=out iset=I1 prefix14_class=7007
cmp P3, P2
cmovle S0, P2
mov S2, P0
cmovl P2, P3
cmovl P3, S0
cmp S2, P1
cmovl S2, P1
cmovl P1, P0
cmp P1, P2
mov S1, P1
cmovle S1, P2
cmovg P1, P2
cmp P3, S2
mov P2, S1
