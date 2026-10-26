# n=5 model=out iset=I1 prefix14_class=9065
mov S0, P0
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
mov S2, P1
cmp S0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, S2
