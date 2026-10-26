# n=5 model=out iset=I1 prefix14_class=8987
cmp P1, P2
mov S0, P3
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
cmp S0, P0
cmovl P3, P0
cmovge S0, P0
cmp P2, P3
cmovle P0, P2
cmovge P0, P3
cmovge P3, P2
cmovge P2, P0
cmp S0, P1
