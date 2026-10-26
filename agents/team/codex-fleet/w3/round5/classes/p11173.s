# n=5 model=out iset=I1 prefix14_class=11173
mov S1, P0
cmp S1, P1
cmovge P0, P1
cmovge P1, S1
cmp P3, P2
mov S0, P0
mov S2, P2
cmovle P2, P3
cmovg S2, P3
cmp P1, S2
cmovl S1, S2
cmovl S2, P1
cmovl P1, S1
cmp P0, P2
