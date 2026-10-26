# n=5 model=out iset=I1 prefix14_class=7563
mov S0, P2
cmp P2, P0
cmovge S0, P0
mov S2, P1
cmovge P0, P2
cmp P1, P3
cmovl P1, P3
cmovg S2, P3
cmp S0, S2
cmovl P3, S0
cmovle S0, S2
cmovl S2, P3
cmp P0, P1
cmovg P3, P1
