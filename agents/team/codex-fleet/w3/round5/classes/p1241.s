# n=5 model=out iset=I1 prefix14_class=1241
cmp P2, P0
cmovl S0, P0
cmovge S0, P2
cmovle P0, P2
cmp P3, P1
cmovle P2, P1
mov S2, S0
cmovle P1, P3
cmovge P2, P3
cmovge P3, P1
cmp S2, P2
cmovg S0, P2
cmovge P2, S2
mov P2, S0
