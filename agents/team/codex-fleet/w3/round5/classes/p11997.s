# n=5 model=out iset=I1 prefix14_class=11997
mov S2, P3
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovge P1, S0
cmp S2, P2
cmovl S2, P2
cmovle P2, P3
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmovl P2, S1
cmp S2, P0
cmovg P3, S2
