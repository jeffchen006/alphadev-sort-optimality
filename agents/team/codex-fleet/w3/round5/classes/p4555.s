# n=5 model=out iset=I1 prefix14_class=4555
mov S0, P2
cmp P2, P1
mov S2, P0
cmovg P2, P1
cmovle S0, P1
cmovge P1, S0
cmp S2, P3
cmovge S2, P3
cmovl P0, P3
cmp P0, P1
cmovg P1, P0
cmovg P0, S2
cmovl S0, P0
cmp P2, S2
