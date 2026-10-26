# n=5 model=out iset=I1 prefix14_class=2645
cmp P2, P1
mov S0, P3
cmovge S2, P2
cmovg P2, P1
cmovl S2, P1
mov P1, S2
cmp P0, P3
cmovge P3, P0
cmovle S0, P0
cmp P3, S2
cmovle S2, P3
cmovl P3, P1
cmp S0, P2
cmovg P3, P2
