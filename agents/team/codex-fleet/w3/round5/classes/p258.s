# n=5 model=out iset=I1 prefix14_class=258
mov S2, P3
cmp P1, P0
mov S0, P1
cmovge P1, P0
cmovge P0, S0
cmovge S0, P1
cmp P2, P3
cmovle S2, P2
cmovg P3, P2
cmp S2, S0
cmovl S0, S2
cmovl S2, P1
cmp P0, P3
mov P2, S2
