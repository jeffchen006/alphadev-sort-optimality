# n=5 model=out iset=I1 prefix14_class=9731
cmp P0, P1
mov S0, P1
cmovl P1, P0
cmovge S0, P0
cmp P2, P3
cmovge P0, P2
cmovle P0, P3
cmovl P3, P2
cmovl P2, P0
cmp S0, P0
cmovg P2, S0
cmovle P0, S0
cmp P1, P3
cmovge S0, P0
