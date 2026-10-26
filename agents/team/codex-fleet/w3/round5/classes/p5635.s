# n=5 model=out iset=I1 prefix14_class=5635
cmp P1, P2
mov S0, P3
cmovge S2, P2
cmovge P2, P1
cmovg P1, S2
mov S1, P2
cmp P0, P3
cmovl S0, P0
cmovge P3, P0
cmovge P0, S0
cmp P1, S0
cmovle P0, P1
cmovge S0, P1
cmp S1, P3
