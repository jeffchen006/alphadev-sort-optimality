# n=5 model=out iset=I1 prefix14_class=97
mov S1, P0
cmp P2, S1
cmovg P0, P2
cmovge P2, S1
mov S2, P3
cmp P1, S2
cmovle P3, P1
cmovg S2, P1
cmp P2, P3
cmovl P1, P3
cmovge P1, P2
cmovle P3, P2
cmp S2, P0
cmovl S0, S2
