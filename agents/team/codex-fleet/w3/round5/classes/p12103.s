# n=5 model=out iset=I1 prefix14_class=12103
mov S1, P0
cmp P1, P3
cmovge S2, P3
cmovg P3, P1
cmovg P1, S2
cmp P2, S1
cmovge P0, P2
cmovl S1, P2
mov S0, P1
cmp S1, S0
cmovl S0, S1
cmovle S1, P1
cmp P3, P0
cmovg P2, P3
