# n=5 model=out iset=I1 prefix14_class=10512
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
mov S0, P0
cmovle S2, P2
cmp P0, P3
cmovge P0, P3
mov S1, P0
cmovle S0, P3
cmp S0, P1
cmovl P3, S0
cmovl S0, P1
cmovl P1, P3
cmp S1, S2
