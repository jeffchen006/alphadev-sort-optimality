# n=5 model=out iset=I1 prefix14_class=9146
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovg S1, P1
mov S0, P0
cmp P3, P2
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
cmp S0, P2
cmovg S0, P2
cmovge P2, P0
cmp S1, P3
cmovl S2, P3
