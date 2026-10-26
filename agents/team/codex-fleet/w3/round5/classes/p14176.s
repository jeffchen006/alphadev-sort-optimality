# n=5 model=out iset=I1 prefix14_class=14176
mov S1, P1
mov S0, P2
cmp P0, P1
cmovg S1, P0
cmovle P1, P0
cmp P2, P3
cmovl S0, P3
cmovge P2, P3
cmp S1, S0
cmovg S2, S1
cmovg S1, S0
cmovg S0, S2
cmp P1, P2
cmovl P0, P2
