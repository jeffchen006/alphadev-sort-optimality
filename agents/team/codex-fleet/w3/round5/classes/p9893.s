# n=5 model=out iset=I1 prefix14_class=9893
cmp P1, P0
mov S0, P1
cmovge P1, P0
cmovge P0, S0
cmp P3, P2
mov S2, P3
cmovl S2, P2
mov S1, P0
cmovle P2, P3
cmp S2, P0
cmovl S1, S2
cmovl S2, P0
cmp P2, P1
mov S2, S1
