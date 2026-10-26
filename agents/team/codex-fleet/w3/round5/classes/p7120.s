# n=5 model=out iset=I1 prefix14_class=7120
cmp P3, P0
cmovl S1, P0
mov S2, P1
cmovle P0, P3
cmovl P3, S1
cmp S2, P2
cmovl P1, P2
cmovle P2, S2
cmp P2, P0
mov S2, P2
cmovl S2, P0
cmovge P2, P0
cmp P1, P3
cmovg S0, P3
