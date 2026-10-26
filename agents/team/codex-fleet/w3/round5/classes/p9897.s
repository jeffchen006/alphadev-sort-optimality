# n=5 model=out iset=I1 prefix14_class=9897
mov S2, P1
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovg P0, S1
cmp P1, P2
cmovle S2, P2
mov S0, P0
cmovl P2, P1
cmp S2, P0
cmovl S0, S2
cmovl S2, P0
cmp P3, P2
mov S2, S0
