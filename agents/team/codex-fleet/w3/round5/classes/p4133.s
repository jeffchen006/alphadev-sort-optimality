# n=5 model=out iset=I1 prefix14_class=4133
mov S0, P3
cmp P2, P3
cmovge P3, P2
cmovl S0, P2
cmp P1, P0
mov P2, P0
cmovge P0, P1
cmovle P2, P1
cmp S0, P2
cmovge S1, P2
mov P1, P0
cmovge P2, S0
cmovg S0, S1
cmp P3, P0
