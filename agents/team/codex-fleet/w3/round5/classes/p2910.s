# n=5 model=out iset=I1 prefix14_class=2910
mov S0, P0
cmp P1, P0
mov S1, P2
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
cmovge P2, P3
mov S2, P0
cmovge P3, S1
cmp P2, S2
cmovl S2, P2
cmovl P2, P0
cmp S0, P3
cmovle P2, S0
