# n=5 model=out iset=I1 prefix14_class=11425
cmp P1, P3
cmovl S1, P3
mov S0, P0
cmovge S1, P1
cmovge P1, P3
cmp S0, P2
cmovg P0, P2
cmovg P2, S0
cmp P1, P0
mov S2, P1
cmovle S2, P0
cmovl P0, P1
cmp P2, S1
cmovge P1, S1
