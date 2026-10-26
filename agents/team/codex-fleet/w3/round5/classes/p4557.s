# n=5 model=out iset=I1 prefix14_class=4557
mov S0, P2
mov S2, P1
cmp P2, P0
cmovg P2, P0
cmovle S0, P0
cmovge P0, S0
cmp P1, P3
cmovge P1, P3
cmovl S2, P3
cmp S2, P0
cmovg P0, S2
cmovl S0, S2
cmp P2, P1
cmovge S2, P2
