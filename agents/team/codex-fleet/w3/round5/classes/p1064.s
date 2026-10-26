# n=5 model=out iset=I1 prefix14_class=1064
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovle P1, S2
mov S0, P2
cmp S0, P3
cmovge S0, P3
cmovg P3, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
mov P2, P1
cmp S0, P2
