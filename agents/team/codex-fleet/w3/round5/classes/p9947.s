# n=5 model=out iset=I1 prefix14_class=9947
cmp P1, P0
cmovl S0, P0
cmovge S0, P1
cmovl P0, P1
cmp P2, P3
cmovge P1, P2
cmovg P2, P3
cmovge P3, P1
cmp S0, P3
cmovge S2, S0
cmovge S0, P3
cmovle S2, P3
mov S2, P2
cmp S2, P0
