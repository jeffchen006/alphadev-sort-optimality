# n=5 model=out iset=I1 prefix14_class=780
cmp P1, P3
mov S2, P1
mov S0, P2
cmovle S2, P3
cmovl P3, P1
cmovl P1, S2
cmp S0, P0
cmovl P2, P0
cmovge S0, P0
cmp P2, S2
cmovl S2, P2
mov S1, S0
cmovge P1, P2
cmp S0, P3
