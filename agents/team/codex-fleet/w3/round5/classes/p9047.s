# n=5 model=out iset=I1 prefix14_class=9047
cmp P3, P2
mov S1, P2
cmovl S1, P3
cmovl P3, P2
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovle S0, P1
mov P2, S0
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp S0, S1
