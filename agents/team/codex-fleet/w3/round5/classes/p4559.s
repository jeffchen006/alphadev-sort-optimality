# n=5 model=out iset=I1 prefix14_class=4559
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovge S0, P0
cmovge P0, P2
mov S2, P3
cmp P3, P1
cmovl S2, P1
cmovg P3, P1
cmp S2, P0
cmovg P2, S2
cmovl P0, S2
cmp S0, P3
cmovg S2, S0
