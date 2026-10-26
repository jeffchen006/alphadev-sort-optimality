# n=5 model=out iset=I1 prefix14_class=7041
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
mov S1, P3
cmovge P2, S0
cmp S1, P1
cmovge S1, P1
cmovl P3, P1
cmp S1, P2
cmovle S0, P2
cmovl P2, S1
cmovl S1, S0
cmp P3, P0
cmovle S0, P0
