# n=5 model=out iset=I1 prefix14_class=14232
mov S1, P0
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp S1, P3
cmovl S1, P3
cmovl P3, P0
mov S0, P2
cmp P2, S1
cmovge P2, S1
cmovg S1, S0
cmp P1, P3
cmovle S2, P1
