# n=5 model=out iset=I1 prefix14_class=10880
cmp P0, P2
mov S2, P0
cmovle P0, P2
cmovg S2, P2
cmp P1, P3
cmovge S1, P3
cmovge P3, P1
mov S0, P3
cmovg P1, S1
cmp S0, P0
cmovg P3, P0
cmovge P0, S0
cmp S2, P1
cmovl S0, P1
