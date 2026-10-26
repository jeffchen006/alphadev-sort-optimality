# n=5 model=out iset=I1 prefix14_class=3875
mov S0, P1
cmp P1, P0
mov S2, P2
cmovge S0, P0
cmovge P0, P1
mov S1, S0
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
cmp S1, P3
cmovl S0, P3
cmovle P3, S1
cmp P0, S2
cmovl P1, S2
