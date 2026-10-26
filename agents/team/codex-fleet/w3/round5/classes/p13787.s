# n=5 model=out iset=I1 prefix14_class=13787
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
mov S2, P0
cmovge P3, S0
cmp S2, P1
cmovg P0, P1
cmovl S2, P1
cmovge P1, S2
cmp P3, P1
cmovl S2, P3
cmovg P1, P3
cmp P2, P0
cmovle S1, P0
