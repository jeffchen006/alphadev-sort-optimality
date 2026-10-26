# n=5 model=out iset=I1 prefix14_class=10882
cmp P3, P2
mov S2, P0
cmovg S0, P3
cmovge P3, P2
cmovg P2, S0
mov S1, P2
cmp P0, P1
cmovge P0, P1
cmovl S2, P1
cmp S2, S1
cmovl S1, S2
cmovg P2, S2
cmp P3, P0
cmovle S2, P0
