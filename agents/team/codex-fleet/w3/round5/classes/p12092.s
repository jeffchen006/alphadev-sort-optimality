# n=5 model=out iset=I1 prefix14_class=12092
mov S1, P1
cmp P2, P1
mov S0, P0
cmovge P1, P2
cmovg P2, S1
cmp P3, S0
cmovl S0, P3
cmovle P3, P0
cmp S0, P2
cmovle P0, P2
cmovl P2, S0
cmovl S0, P0
cmp P1, P3
cmovge S1, P3
