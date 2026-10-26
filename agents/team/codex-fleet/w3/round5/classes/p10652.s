# n=5 model=out iset=I1 prefix14_class=10652
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
mov S2, P3
cmovl P0, S1
cmp P2, S2
mov S0, P0
cmovg S2, P2
cmovge P2, P3
cmp S0, S2
cmovge P0, S2
mov P3, P2
cmovge S2, S0
cmp P1, P2
