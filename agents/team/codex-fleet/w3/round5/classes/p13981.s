# n=5 model=out iset=I1 prefix14_class=13981
cmp P1, P3
mov S0, P0
cmovle S2, P1
cmovl P1, P3
cmovl P3, S2
cmp S0, P2
cmovge P0, P2
cmovge P2, S0
cmovl S0, P2
cmp P1, S0
cmovl S0, P1
cmovg P2, P1
cmp P3, P0
cmovl S1, P0
