# n=5 model=out iset=I1 prefix14_class=10093
cmp P3, P1
cmovge S2, P3
cmovle S2, P1
cmovl P1, P3
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovg P0, S0
cmp S2, P0
cmovl S0, S2
mov P3, P2
cmovle S2, P0
cmovl P0, S0
cmp P1, P3
