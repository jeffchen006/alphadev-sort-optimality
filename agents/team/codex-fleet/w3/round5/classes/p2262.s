# n=5 model=out iset=I1 prefix14_class=2262
mov S0, P3
cmp S0, P2
cmovl S0, P2
cmovge P3, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovle P2, P0
cmovge P0, P2
cmp P2, S0
cmovle P2, S0
mov P2, P3
cmovl S0, P0
cmp P3, P1
