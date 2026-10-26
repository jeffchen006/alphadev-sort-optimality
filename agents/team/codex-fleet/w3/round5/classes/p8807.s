# n=5 model=out iset=I1 prefix14_class=8807
mov S2, P3
cmp S2, P1
mov S0, P0
cmovle P3, P1
cmovl P1, S2
cmp P2, S0
cmovle P0, P2
cmovge S0, P2
cmp S0, P3
cmovge P2, P3
cmovge P3, S0
cmovge S0, P2
cmp P0, P1
cmovle P2, P0
