# n=5 model=out iset=I1 prefix14_class=13091
cmp P1, P3
cmovge S2, P1
mov S0, P0
cmovge P1, P3
cmovge P3, S2
cmp P0, P2
cmovge P0, P2
cmovl S0, P2
cmovle P2, P0
cmp P1, P0
cmovge P0, P1
cmovle P2, P1
mov P2, S0
cmp S0, P3
