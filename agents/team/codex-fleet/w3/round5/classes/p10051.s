# n=5 model=out iset=I1 prefix14_class=10051
mov S1, P0
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
mov S0, P3
mov S2, S1
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmp P1, S1
cmovge S2, P1
cmovge P1, S1
cmp S0, P2
cmovl S1, P2
