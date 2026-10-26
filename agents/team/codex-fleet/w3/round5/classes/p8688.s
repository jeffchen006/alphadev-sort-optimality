# n=5 model=out iset=I1 prefix14_class=8688
mov S2, P2
cmp P3, S2
cmovl S2, P3
mov S0, P1
cmovge P2, P3
cmp S0, P0
cmovg P1, P0
cmovl S0, P0
cmp S0, P2
cmovge S1, S0
cmovl S1, P2
cmovle P2, S0
cmp S2, P1
cmovge P3, S2
