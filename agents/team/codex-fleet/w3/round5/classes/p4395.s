# n=5 model=out iset=I1 prefix14_class=4395
mov S2, P3
mov S0, P1
cmp P0, S2
cmovge P3, P0
cmovge P0, S2
cmp P2, P1
cmovge S0, P2
cmovle P1, P2
cmovl P2, S0
cmp P3, S0
cmovge P2, P3
cmovge P3, S0
cmp P0, P1
cmovge S0, P0
