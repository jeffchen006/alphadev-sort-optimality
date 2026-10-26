# n=5 model=out iset=I1 prefix14_class=7128
mov S0, P0
cmp P1, P0
cmovl P0, P1
mov S2, P2
cmovle P1, S0
cmp P2, P3
cmovl S2, P3
cmovge P2, P3
cmp P0, P2
cmovl P3, P2
cmovle P2, P0
cmovge P3, P0
cmp S2, P1
cmovge P2, S2
