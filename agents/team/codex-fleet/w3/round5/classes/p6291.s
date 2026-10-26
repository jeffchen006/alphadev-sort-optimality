# n=5 model=out iset=I1 prefix14_class=6291
cmp P1, P0
mov S1, P3
cmovg S0, P0
cmovle S0, P1
cmovge P0, P1
cmp P2, P3
cmovge S1, P2
mov S2, P0
cmovg P2, P3
cmp S2, S1
cmovl S2, S1
cmovl S1, P0
cmp P2, S0
cmovg P0, P2
