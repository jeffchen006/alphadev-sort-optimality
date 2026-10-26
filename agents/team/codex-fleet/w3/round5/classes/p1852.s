# n=5 model=out iset=I1 prefix14_class=1852
cmp P0, P3
mov S2, P3
cmovl S2, P0
mov S0, P2
cmovge P3, P0
cmp P1, S0
cmovg P2, P1
cmovge P1, S0
mov S1, P2
cmp S1, P3
cmovl S1, P3
cmovle P3, P2
cmp S2, P1
cmovl P0, S2
