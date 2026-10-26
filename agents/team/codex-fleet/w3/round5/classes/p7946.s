# n=5 model=out iset=I1 prefix14_class=7946
cmp P2, P1
cmovle S0, P2
cmovge S0, P1
cmovl P2, P1
cmp P0, P3
cmovge P1, P0
mov S2, S0
cmovg P0, P3
cmovg P3, P1
cmp S2, P0
cmovge S2, P0
mov S1, P2
cmovl S0, P0
cmp P2, P3
