# n=5 model=out iset=I1 prefix14_class=5819
mov S2, P0
cmp S2, P1
cmovl P0, P1
mov S0, P3
cmovl P1, S2
cmp S0, P2
cmovl S0, P2
mov S1, P1
cmovl P2, P3
cmp S1, P2
cmovg S1, P2
cmovle P1, P2
cmp P0, S0
cmovge P3, P0
