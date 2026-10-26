# n=5 model=out iset=I1 prefix14_class=10280
mov S2, P3
cmp S2, P2
cmovge S2, P2
cmovle P3, P2
mov S0, P1
mov S1, S2
cmp S0, P0
cmovge P1, P0
cmovge P0, S0
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovle P3, P2
cmp S2, P1
