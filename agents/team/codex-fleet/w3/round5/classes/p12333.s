# n=5 model=out iset=I1 prefix14_class=12333
mov S2, P1
cmp P0, P2
mov S0, P0
cmovl P0, P2
cmovge S0, P2
cmp P1, P3
cmovl S2, P3
cmovge P1, P3
mov S1, S0
cmp S0, P1
cmovg S1, P1
cmovl S0, P1
cmp S2, P0
cmovle P3, S2
