# n=5 model=out iset=I1 prefix14_class=2105
cmp P0, P1
cmovle S0, P1
cmovg S0, P0
cmovl P1, P0
cmp P3, P2
cmovl S1, P2
cmovge S1, P3
cmovg P3, P2
cmp S0, S1
cmovge P2, S1
cmovge S1, S0
mov S1, P3
cmovge S0, P2
cmp P3, P1
