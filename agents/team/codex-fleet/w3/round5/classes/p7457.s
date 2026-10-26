# n=5 model=out iset=I1 prefix14_class=7457
mov S2, P1
cmp P2, S2
cmovge S2, P2
cmovge P2, P1
mov S0, P0
cmp P0, P3
cmovge S0, P3
cmovle P0, P3
mov S1, S0
cmp P2, S0
cmovl S1, P2
cmovl P2, S0
cmp P0, S2
cmovge P1, S2
