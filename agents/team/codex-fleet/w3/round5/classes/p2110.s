# n=5 model=out iset=I1 prefix14_class=2110
cmp P1, P0
cmovge S0, P0
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
cmovg S2, P3
cmovle S2, P2
cmovge P3, P2
cmovg P2, S2
cmp P0, S2
cmovge S2, P0
mov S2, S0
cmovg P0, P2
cmp S2, P3
