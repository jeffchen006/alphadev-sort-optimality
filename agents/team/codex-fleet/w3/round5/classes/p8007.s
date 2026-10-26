# n=5 model=out iset=I1 prefix14_class=8007
mov S1, P0
cmp P2, S1
cmovge P0, P2
cmovg P2, S1
cmp P1, P3
cmovl S1, P3
mov S2, P0
mov S0, P2
cmovle P3, P1
cmovl P1, S1
cmp P3, S0
cmovl P2, P3
cmovge S0, P3
cmp S2, P1
