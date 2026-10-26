# n=5 model=out iset=I1 prefix14_class=5648
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovle P1, P0
mov S0, P2
cmp P3, S0
cmovl S0, P3
cmovge P2, P3
mov S2, S0
cmp S2, P1
cmovl S0, P1
cmovge S2, P1
cmp P2, S1
cmovle P1, P2
