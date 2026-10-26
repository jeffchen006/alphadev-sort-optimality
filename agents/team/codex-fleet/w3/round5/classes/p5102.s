# n=5 model=out iset=I1 prefix14_class=5102
mov S0, P3
cmp S0, P1
cmovg P3, P1
cmovl S0, P1
mov S2, P3
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
cmovge P2, P0
cmp P3, P2
cmovle P3, P2
cmovl P2, S2
cmp S1, S0
cmovge P0, S0
