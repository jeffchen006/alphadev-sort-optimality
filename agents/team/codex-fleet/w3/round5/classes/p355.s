# n=5 model=out iset=I1 prefix14_class=355
cmp P0, P3
mov S1, P2
cmovge S0, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
mov S2, P0
cmovge P2, P1
cmovge P1, S1
cmp P2, S2
cmovle S2, P2
cmovl P2, P0
mov S1, S0
cmp P1, S1
