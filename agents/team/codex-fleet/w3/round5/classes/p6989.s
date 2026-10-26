# n=5 model=out iset=I1 prefix14_class=6989
cmp P0, P2
mov S0, P2
mov S1, P1
cmovl S0, P0
cmovge P2, P0
cmp P3, P1
cmovl S1, P3
mov S2, S0
cmovl P3, P1
cmp S1, S2
cmovl S0, S1
cmovle S1, S2
cmp P2, P3
cmovge P0, P2
