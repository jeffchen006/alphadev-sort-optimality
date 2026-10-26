# n=5 model=out iset=I1 prefix14_class=10318
mov S0, P2
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P0, P2
cmovg P2, P0
cmovl S0, P0
cmp P2, S2
cmovge P1, S2
cmovge S2, P2
cmovge P2, P1
cmp S0, P3
cmovge P0, S0
