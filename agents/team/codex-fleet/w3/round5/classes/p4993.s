# n=5 model=out iset=I1 prefix14_class=4993
cmp P3, P0
mov S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P0, P2
cmovl S1, P2
cmovle P2, P0
mov S2, P3
cmovl P0, S1
cmp S2, P1
