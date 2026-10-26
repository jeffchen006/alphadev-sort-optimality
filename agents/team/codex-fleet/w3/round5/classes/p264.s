# n=5 model=out iset=I1 prefix14_class=264
mov S2, P1
cmp P1, P0
cmovge P1, P0
cmovge P0, S2
mov S0, P2
cmp P3, P2
cmovle S0, P3
mov S2, P1
cmovg P2, P3
cmp S0, P1
cmovl S2, S0
cmovl S0, P1
cmp P0, P2
mov P3, P2
