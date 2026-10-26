# n=5 model=out iset=I1 prefix14_class=5166
mov S1, P0
cmp P0, P1
mov S0, P3
cmovle P0, P1
cmovl P1, S1
cmp P2, S0
cmovl S0, P2
cmovl P2, P3
cmp S0, P1
cmovge P3, S0
cmovge S0, P1
cmovg P1, P3
mov S0, P0
cmp P2, S0
