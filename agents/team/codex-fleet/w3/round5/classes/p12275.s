# n=5 model=out iset=I1 prefix14_class=12275
mov S2, P0
cmp P3, P0
cmovle S2, P3
cmovg P0, P3
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
mov P3, S2
cmovg P1, S0
cmp S2, P1
cmovge P3, P1
cmovge P1, S2
cmp P2, P0
cmovl S2, P0
