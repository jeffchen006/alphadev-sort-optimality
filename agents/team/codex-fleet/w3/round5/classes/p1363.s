# n=5 model=out iset=I1 prefix14_class=1363
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovl S1, P3
cmp P0, P1
mov S0, P1
mov P3, P2
cmovl S0, P0
cmovge P1, P0
cmp P1, P2
cmovge P3, P1
cmovge P1, P2
cmp S0, S1
cmovle P2, S1
