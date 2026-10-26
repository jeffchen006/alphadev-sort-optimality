# n=5 model=out iset=I1 prefix14_class=5677
mov S1, P3
cmp S1, P1
cmovge S1, P1
mov S2, S1
cmovge P1, P3
cmp P0, P2
mov S0, P2
cmovg P2, P0
cmovl S0, P0
cmp S0, S1
cmovl S1, S0
cmovl S0, S2
cmp P1, P2
cmovle S2, P1
