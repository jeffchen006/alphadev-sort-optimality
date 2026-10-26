# n=5 model=out iset=I1 prefix14_class=6763
mov S0, P0
cmp P1, P3
cmovge S2, P3
cmovl S2, P1
cmovle P1, P3
cmp S0, P2
cmovge P0, P2
mov P3, P0
cmovl S0, P2
cmp S0, P1
cmovge P2, S0
cmovge S0, P1
mov S1, S0
cmovg P1, P2
