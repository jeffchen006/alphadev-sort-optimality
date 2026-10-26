# n=5 model=out iset=I1 prefix14_class=9394
mov S2, P2
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovg P1, P0
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
cmp P1, S2
cmovge P2, P1
cmovg P1, S2
cmovge S2, P2
mov S1, S0
cmp S1, P3
