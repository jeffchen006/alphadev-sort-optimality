# n=5 model=out iset=I1 prefix14_class=8137
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmovl S2, P3
cmp P0, P2
cmovge P3, P2
cmovg P2, P0
mov S1, S2
cmovge P0, P3
cmp S1, P0
cmovge S2, P0
cmovle S1, P0
mov S0, P2
cmp P2, P1
