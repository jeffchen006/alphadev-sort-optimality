# n=5 model=out iset=I1 prefix14_class=9206
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
mov S0, P2
cmovl P3, S1
cmp P0, S0
cmovle S0, P0
mov S2, S0
cmovg P2, P0
mov P0, P3
cmp S0, P1
cmovge S2, P1
cmovge P1, S0
cmp P3, P2
