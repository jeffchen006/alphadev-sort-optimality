# n=5 model=out iset=I1 prefix14_class=3263
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmovl S2, P0
mov S0, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, S0
cmp S2, P3
cmovle P0, P3
cmovge S2, P3
cmp P1, P2
cmovg S0, P2
