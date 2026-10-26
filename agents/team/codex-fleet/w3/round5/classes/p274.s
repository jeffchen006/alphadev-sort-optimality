# n=5 model=out iset=I1 prefix14_class=274
mov S0, P2
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovge P3, S2
cmp P1, P2
cmovl S0, P1
cmovg P2, P1
cmp S0, P0
mov S1, P0
cmovl P0, S0
cmovle S0, S1
cmp P2, P3
mov P1, P3
