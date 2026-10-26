# n=5 model=out iset=I1 prefix14_class=7205
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovge S0, P3
cmp P2, P0
mov S2, P0
cmovg P0, P2
cmovle S2, P2
mov S1, S2
cmp S2, S0
cmovl S2, S0
cmovg S1, S0
cmp P1, P0
cmovl S0, P1
