# n=5 model=out iset=I1 prefix14_class=4994
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P2, P1
cmovg S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
mov S0, P3
cmovl P0, S2
cmp S0, P1
